require_relative 'content'
require_relative 'renderer'
require_relative 'detector'

module DuperVisor
  class CLIError < ArgumentError
  end

  class Config
    attr_accessor :to, :output

    def initialize(to: nil, output: nil)
      self.to      = to
      self.output  = output
    end

    def validate!
      raise CLIError.new('Either the output format or filename is required!') unless to

      self.output = if output.is_a?(String) && output != ''
                      File.open(output, 'w')
                    elsif output.respond_to?(:puts)
                      output
                    else
                      STDOUT
                    end
    end
  end
end
