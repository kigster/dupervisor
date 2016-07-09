require_relative 'generator'
require_relative 'detector'
require_relative 'content'
require 'awesome_print'
require 'pp'
module DuperVisor
  class Main
    attr_accessor :config, :content

    def initialize(config)
      self.config = config
    end

    def run
      config.validate!
      Generator.new(config.output, config.input).generate(config.to)
    end

  end
end
