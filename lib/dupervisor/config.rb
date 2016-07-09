require_relative 'content'
require_relative 'generator'
require_relative 'detector'

module DuperVisor
  class CLIError < ArgumentError
  end

  class Config
    attr_accessor :from, :to, :output, :input, :verbose

    def initialize(to: nil, output: nil, verbose: false)
      self.to      = to
      self.verbose = verbose
      self.output  = output
    end

    def validate!
      construct
      raise CLIError.new('Either the output format or filename is required!') unless to
      self
    end

    private


    def construct
      self.input  = Content.new(body:   ARGF.read,
                                format: ExtensionDetector.new(ARGF.filename).detect)
      self.from   ||= input.format
      self.to     = ExtensionDetector.new(output).detect unless to
      self.output = output.is_a?(String) && output != '' ? File.open(output, 'w') : STDOUT
    end

  end
end
