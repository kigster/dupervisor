# frozen_string_literal: true

require 'inifile'
require_relative '../formats'
require_relative '../errors'

module DuperVisor
  module Formats
    class Ini < Base
      def self.transform
        delete_keys = ::Set.new
        keys_to_add = {}
        hash        = yield(keys_to_add, delete_keys)
        delete_keys.each { |k| hash.delete(k) }
        hash.merge!(keys_to_add)
      end

      errors [IniFile::Error]

      from ->(string) do
        hash = IniFile.new(content: string).to_h
        Ini.transform do |keys_to_add, delete_keys|
          hash.keys.select { |k| hash[k].is_a?(Hash) && k =~ /.*:.*/ }.each do |key|
            outer, inner = key.split(/:/)
            keys_to_add[outer] ||= {}
            keys_to_add[outer][inner] = hash[key]
            delete_keys << key
          end
          hash
        end
      end

      to ->(object) do
        # unless object.is_a?(Hash)
        #   raise Errors::DataTypeNotSupported, "Only Hash input data type is supported by INI file converter."
        # end
        #
        Ini.transform do |keys_to_add, delete_keys|
          object.keys.select { |k| object[k].is_a?(Hash) }.each do |key|
            object[key].keys.select { |k| object[key][k].is_a?(Hash) }.each do |sub_key|
              keys_to_add["#{key}:#{sub_key}"] = object[key][sub_key]
              delete_keys << key
            end
          end
          object
        end
        IniFile.new.merge!(object).to_s
      end
    end
  end
end
