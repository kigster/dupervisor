module Dupervisor
  class Config
    attr_accessor :from, :to, :input, :output, :verbose

    def initialize(from: :auto, to: nil, input: nil, output: nil, verbose: false)
      self.from    = from
      self.to      = to
      self.verbose = verbose

      self.input   = input
      self.output  = output

      self.input   ||= STDIN
      self.output  ||= STDOUT
    end
  end
end
