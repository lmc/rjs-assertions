class JSFunctionCall
  attr_accessor :name, :arguments
  attr_accessor :klass
  attr_accessor :options
  
  def initialize(klass_maybe_name,*arguments)
    klass_maybe_name.gsub!(/^new /,'') if klass_maybe_name.is_a?(String)
    klass_maybe_name = klass_maybe_name.to_s if klass_maybe_name.is_a?(Symbol)
    if klass_maybe_name.is_a?(Array)
      self.klass,self.name = *klass_maybe_name
    elsif(klass_maybe_name.is_a?(String))
      if klass_maybe_name.match(/\./)
        self.klass,self.name = klass_maybe_name.split('.')
      else
        self.klass,self.name = nil,klass_maybe_name
      end
    end
    self.arguments = arguments
    if self.arguments.last.is_a?(Hash)
      self.options = self.arguments.pop 
    else
      self.options = {}
    end
    self.options.stringify_keys!
  end
  
  def self.reflect(js_string)
    matches = js_string.match(/(.*?)\((.*)\);?$/)
    args = ActiveSupport::JSON.decode("[#{matches[2]}]")
    i = new(matches[1],*args)
    i
  end
  
  def specified_equal?(other)
    return false unless self.klass === other.klass
    return false unless self.name === other.name
    return false unless specified_arguments_equal?(other)
    return false unless specified_options_are_equal?(other)
    return true
  end
  
  def specified_arguments_equal?(other)
    matches = true
    self.arguments.each_with_index do |argument,offset|
      unless argument === other.arguments[offset]
        matches = false
        break
      end
    end
    matches
  end
  
  def specified_options_are_equal?(other)
    matches = true
    self.options.each_pair do |key,value|
      unless value === other.options[key]
        debugger
        matches = false
        break
      end
    end
    matches
  end
end