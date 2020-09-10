# An Abstract factory provides an interface for creating families of related 
# objects without specifying their concrete classes

# Abstract class
class GadgetsFactory
  def createPhone
    raise NotImplementedError, "phone interface not implemented"
  end

  def createComputer
    raise NotImplementedError, "computer interface not implemented"
  end
end


class AppleFactory < GadgetsFactory
  def createPhone
    ApplePhone.new
  end

  def createComputer
    AppleComputer.new
  end
end


class WindowsFactory < GadgetsFactory
  def createPhone
    WindowsPhone.new
  end

  def createComputer
    WindowsComputer.new
  end
end

class Phone
  attr_reader :model
  def initialize(model, os_version)
    @model = model
    @os_version = os_version
  end

  def camera
  end

  def price
  end

  def ram
  end

  def cpu
  end
end

class WindowsPhone < Phone

end

class ApplePhone < Phone
end

class Computer
  def price
  end

  def ram
  end

  def cpu
  end

  def processor_speed
  end
end

class WindowsComputer < Computer

end

class AppleComputer < Computer
end

class Application

end