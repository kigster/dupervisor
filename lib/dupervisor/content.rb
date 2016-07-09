require 'YAML'
require 'JSON'
require 'inifile'

module DuperVisor
  class Content
    class ParseError < StandardError
    end

    attr_accessor :body, :hash, :format, :errors

    def initialize(body: nil, format: nil)
      self.body   = body
      self.hash   = {}
      self.format = parse(format) || autodetect
      self.errors = {}
    end

    def success?
      !self.hash.empty?
    end

    def error(format)
      errors[format]
    end

    def parse(format)
      send("#{format}_check") if format
    end

    def autodetect
      %i(yaml json ini).each do |format|
        begin
          read(format)
        rescue ParseError => e
          errors[format] = e
        end
      end
    end

    def yaml_check
      self.hash = YAML.load(body)
      :yaml
    rescue Psych::SyntaxError => e
      raise ParseError.new(e)
    end

    def json_check
      self.hash = JSON.parse(body)
      :json
    rescue JSON::ParserError => e
      raise ParseError.new(e)
    end

    def ini_check
      self.hash = IniFile.new(content: body).to_h
      :ini
    rescue IniFile::Error => e
      raise ParseError.new(e)
    end
  end

end
