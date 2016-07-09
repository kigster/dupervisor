require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'pp'
require_relative 'config'

module DuperVisor
  class CLI
    attr_accessor :args, :config, :parser

    def initialize(args)
      self.args    = args
      self.config = Config.new
    end

    def parse
      self.parser = OptionParser.new do |opts|
        opts.banner = 'Usage: '.bold.blue + 'DuperVisor [options] [source-file]'.bold.green
        opts.separator ''
        opts.separator '       Convert between several hierarchical configuration'
        opts.separator '       file formats, such as ' + 'ini, yaml, json'.bold.green
        opts.separator ''
        opts.separator 'Specific options:'.bold.blue

        opts.on('--ini', 'Assume the output is INI file') do |file|
          config.to = :ini
        end
        opts.on('--yaml', 'Assume the output is YAML file') do |file|
          config.to = :yaml
        end
        opts.on('--json', 'Assume the output is JSON file') do |file|
          config.to = :json
        end

        opts.on('-o', '--output [FILE]',
                'File to write, if not supplied write to STDOUT',
                'If provided, will be used to guess destination format') do |file|
          config.output = file
        end

        opts.on('-v', '--verbose',
                'Print extra debugging info') do
          config.verbose = true
        end
        opts.separator ''
        opts.separator 'Examples:'.bold.blue
        opts.separator ''
        opts.separator '    # guess input format, convert YAML format to an INI file'
        opts.separator '    cat config.yml | DuperVisor --ini > config.ini'.green
        opts.separator ''
        opts.separator '    # guess input format, convert INI format to a JSON file '
        opts.separator '    DuperVisor --json config.ini > config.json'.green

        opts.separator ''
        opts.separator 'Common options:'.bold.blue

        # No argument, shows at tail.  This will print an options summary.
        # Try it and see!
        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end

        # Another typical switch to print the version.
        opts.on_tail('--version', 'Show version') do
          puts DuperVisor::VERSION
          exit
        end
      end

      parser.parse!(args)


      config
    end
  end
end
