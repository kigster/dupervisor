# frozen_string_literal: true

require_relative 'renderer'
require_relative 'detector'
require_relative 'parser'
require_relative 'content'
require_relative 'errors'
require 'colored2'

module DuperVisor
  class Main
    attr_accessor :config, :from_format, :content

    def initialize(config)
      self.config = config
    end

    def run
      config.validate!
      self.from_format = Detector.new(ARGF.filename).detect
      self.content = Parser.new(ARGF.read).parse(from_format)
      Renderer.new(content.parse_result, config.output).render(config.to)
    rescue DuperVisor::Errors::ParseError => e
      report_error(e)
    end

    def report_error(error)
      puts '  Error:'.bold.white + ' Unable to parse input.'.bold.red
      puts 'Details:'.bold.white + " #{error.inspect}".red
    end
  end
end
