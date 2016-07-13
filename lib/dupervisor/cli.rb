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
        opts.banner = 'Usage: '.bold.blue + 'dv [source-file] [options] '.bold.green
        opts.separator ''
        opts.separator '       Convert between several hierarchical configuration'
        opts.separator '       file formats, such as ' + 'ini, yaml, json'.bold.green
        opts.separator ''
        opts.separator '       Automatically guesses the source format based either on'
        opts.separator '       the file extension, or by attempting to parse it for STDIN'
        opts.separator ''
        opts.separator 'Specific options:'.bold.blue

        opts.on('--ini', 'Generate an INI file') do |file|
          config.to = :ini
        end
        opts.on('--yaml', 'Generate a YAML file') do |file|
          config.to = :yaml
        end
        opts.on('--json', 'Generate a JSON file') do |file|
          config.to = :json
        end

        opts.on('-o', '--output [FILE]',
                'File to write, if not supplied write to STDOUT') do |file|
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
        opts.separator '    cat config.yml | dv --ini > config.ini'.green
        opts.separator ''
        opts.separator '    # guess input format, convert INI format to a JSON file '
        opts.separator '    dv config.ini --json -o config.json'.green

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
