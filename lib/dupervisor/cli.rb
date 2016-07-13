require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'pp'
require_relative 'config'

module DuperVisor
  class CLI
    attr_accessor :args, :config, :parser

    def initialize(args)
      self.args   = args
      self.config = Config.new
    end

    def parse
      self.parser = OptionParser.new do |opts|
        decorator = OptionsDecorator.new(opts, config)
        decorator.usage
        decorator.flags
        decorator.examples
      end

      parser.parse!(args)
      config
    end

    class OptionsDecorator < Struct.new(:opts, :config)

      def flags
        opts.separator 'Options:'.bold.blue.underlined
        opts.separator '  Output Format:'.bold.yellow
        opts.on('--ini', 'Generate an INI file') { config.to = :ini }
        opts.on('--yaml', 'Generate a YAML file') { config.to = :yaml }
        opts.on('--json', 'Generate a JSON file') { config.to = :json }
        opts.separator ''

        opts.separator '  Flags:'.bold.yellow
        opts.on('-o', '--output [FILE]',
                'File to write, STDOUT if none.') do |file|
          config.output = file
        end

        # No argument, shows at tail.  This will print an options summary.
        # Try it and see!
        opts.on('-h', '--help', 'Show this message') do
          puts opts
          exit
        end

        # Another typical switch to print the version.
        opts.on('--version', 'Show version') do
          puts DuperVisor::VERSION
          exit
        end

      end

      def examples
        opts.separator ''
        opts.separator 'Examples:'.bold.blue.underlined
        opts.separator ''
        opts.separator '    # guess input format, convert YAML format to an INI file'
        opts.separator '    cat config.yml | dv --ini > config.ini'.green
        opts.separator ''
        opts.separator '    # guess input format, convert INI format to a JSON file '
        opts.separator '    dv config.ini --json -o config.json'.green

        opts.separator ''
      end

      def usage
        opts.banner = 'Usage:'.bold.blue.underlined + "\n" + '  dv [source-file] [options] '.bold.green
        opts.separator ''
        opts.separator '  Convert between several hierarchical configuration'
        opts.separator '  file formats, such as ' + 'ini, yaml, json.'.bold.green
        opts.separator ''
        opts.separator '  Automatically detects the source format based on either'
        opts.separator '  the file extension, or by attempting to parse STDIN.'
        opts.separator ''
      end
    end
  end
end
