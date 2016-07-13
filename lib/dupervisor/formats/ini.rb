require 'inifile'
require_relative '../formats'
module DuperVisor
  module Formats
    class Ini < Base
      def self.transform_hash
        delete_keys = ::Set.new
        keys_to_add      = {}
        if block_given?
          hash = yield(keys_to_add, delete_keys)
        end
        delete_keys.each { |k| hash.delete(k) }
        hash.merge!(keys_to_add)
      end

      errors [IniFile::Error]

      from ->(string) do
        hash        = IniFile.new(content: string).to_h
        Ini.transform_hash do |keys_to_add, delete_keys|
          hash.keys.select { |k| hash[k].is_a?(Hash) && k =~ /.*:.*/ }.each do |key|
            outer, inner         = key.split(/:/)
            keys_to_add[outer]        ||= {}
            keys_to_add[outer][inner] = hash[key]
            delete_keys << key
          end
          hash
        end
      end

      to ->(hash) do
        Ini.transform_hash do |keys_to_add, delete_keys|
          hash.keys.select { |k| hash[k].is_a?(Hash) }.each do |key|
            hash[key].keys.select { |k| hash[key][k].is_a?(Hash) }.each do |sub_key|
              keys_to_add["#{key}:#{sub_key}"] = hash[key][sub_key]
              delete_keys << key
            end
          end
          hash
        end
        IniFile.new.merge!(hash).to_s
      end
    end
  end
end
