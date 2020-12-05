# Observer is a behavioral design pattern that lets you define a subscription mechanism to 
# notify multiple objects about any events that happen to the object they’re observing.

require "forwardable"

# publishes messages to message subscribers
class Publisher
  def initialize
    @subscribers = {}
  end

  def subscribe(name, handler=nil, &block)
    raise ArgumentError.new("pass a handler") unless handler || block
    
    @subscribers[name] = handler || block
  end

  def unsubscribe(name)
    @subscribers.delete(name)
  end

  def notify(event, payload=nil)
    @subscribers[event]&.call(event, payload)
  end
end

# Wraps a Publisher object, allowing access to the object's interface.
class Notifications
  class << self
    extend Forwardable
    def_delegators :publisher, :subscribe, :unsubscribe, :notify
    alias_method :on, :subscribe
    alias_method :off, :unsubscribe

    private
    def publisher
      @publisher ||= Publisher.new
    end
  end
end

# A subscriber can be any object that responds to #call,
# whether a class/object/module that has a #call method or a Proc
class Subscriber
  def self.call(name, payload)
    p "Customer #{payload[:user_id]} just signed up"
  end
end



Notifications.on "user_logged_in" do |event, payload|
  p "User #{payload[:user_id]} just logged in"
end

Notifications.on "user_signed_up", Subscriber


Notifications.notify("user_logged_in", { user_id: 5, email: "ezeogbonna@gmail.com" })

Notifications.notify("user_signed_up", { user_id: 10, email: "ezeogbonna@gmail.com" })
