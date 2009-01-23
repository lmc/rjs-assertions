module TwoFiftyFive
  module RJSAssertions
    RJS_ADD_NAME_TO_ELEMENT_CLASS = proc { |args| args[0] = ['Element',args[0].to_s]; args }
    RJS_ADD_NAME_TO_EFFECT_CLASS = proc { |args| args[0] = ['Element',args[0].to_s]; args }
    RJS_OUTPUT_FIXES = {
      :call => proc do |args|
        args.shift
        args
      end,
      :hide => RJS_ADD_NAME_TO_ELEMENT_CLASS,
      :show => RJS_ADD_NAME_TO_ELEMENT_CLASS,
      :insert_html => proc do |args|
        args[0] = ['Element','insert']
        element = args[2]
        args[2] = { args[1] => (args.delete_at(3) || /.*/) } 
        args[1] = element
        args
      end,
      :replace_html => proc do |args|
        args[0] = ['Element','update']
        args
      end,
      :visual_effect => proc do |args|
        args[0] = ['Effect',args.delete_at(1).to_s.capitalize]
        args
      end
    }
    
    def assert_rjs(*args)
      original = args.dup
      args = RJS_OUTPUT_FIXES[args.first].call(args) if RJS_OUTPUT_FIXES[args.first]
      response = @response.body.to_s
      parser = RJSResponseReflector.new(response)
      match = JSFunctionCall.new(args.shift,*args)
      #debugger unless parser.include?(match)
      assert parser.include?(match), "Couldn't find a match for #{match.inspect}"
    end
    
    private
    
  end
end