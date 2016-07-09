module DuperVisor
  class Generator
    attr_accessor :output, :content

    def initialize(output_stream, content)
      self.output  = output_stream
      self.content = content
    end

    def generate(format)
      output.write(DumpTo.new(content.hash).format(format))
      output.close unless output == STDOUT
    end

    class DumpTo < Struct.new(:hash)
      def format(format)
        if respond_to?(format)
          send(format)
        end
      end

      def yaml
        YAML.dump(hash)
      end

      def json
        JSON.pretty_generate(hash)
      end

      def ini
        delete_keys = Set.new
        merged      = {}
        hash.keys.select { |k| hash[k].is_a?(Hash) }.each do |key|
          hash[key].keys.select { |k| hash[key][k].is_a?(Hash) }.each do |sub_key|
            merged["#{key}:#{sub_key}"] = hash[key][sub_key]
            delete_keys << key
          end
        end
        delete_keys.each { |k| hash.delete(k) }
        hash.merge!(merged)
        IniFile.new.merge!(hash).to_s
      end
    end
  end
end
