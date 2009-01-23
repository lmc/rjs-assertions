class RJSResponseReflector
  attr_accessor :lines
  attr_accessor :actions
  
  def initialize(response)
    self.lines = response.split("\n")
    self.actions = lines.map { |line| JSFunctionCall.reflect(line) }
  end
  
  def include?(other)
    !!self.actions.select{ |action| other.specified_equal?(action) }.first
  end
end