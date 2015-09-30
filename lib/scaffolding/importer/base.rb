module Scaffolding
  module Importer
    class Base

      def initialize(file="")
        @errors = []
        @data = valid_data?(file)
        @file_name = File.basename(file, ".*" ).to_s.split.join.downcase
        @code_string = "rails g scaffold #{@file_name}"
        @scaffolding = {}
      end

      def errors
        @errors
      end

      def valid_data?(file)
        unless file == ""
          if [".csv", ".xls", ".xlsx"].include? File.extname(file)
            File.read(utf8_encode(file))
          else
            @errors << "Unknown file type: #{File.extname(file)}"
            false
          end
        else
          @errors << "No file selected"
          false
        end
      end

      def utf8_encode(s)
        s.force_encoding(Encoding::ISO_8859_1).encode(Encoding::UTF_8, invalid: :replace, undef: :replace)
      end

    #   def camelize(term, uppercase_first_letter = true)
    #    string = term.to_s
    #    if uppercase_first_letter
    #      string = string.sub(/^[a-z\d]*/) { inflections.acronyms[$&] || $&.capitalize }
    #    else
    #      string = string.sub(/^(?:#{inflections.acronym_regex}(?=\b|[A-Z_])|\w)/) { $&.downcase }
    #    end
    #    string.gsub!(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{inflections.acronyms[$2] || $2.capitalize}" }
    #    string.gsub!(/\//, '::')
    #    string
    #  end

      def code_string
        process_data
        @scaffolding.each do |k, v|
          @code_string << " #{k}:#{v}"
        end
        @code_string
      end

      def self.process(file)
        importer = self.new(file)
        return importer.errors unless importer.errors.count == 0
        importer.code_string.to_s + "; rake db:migrate"
      end

    end
  end
end
