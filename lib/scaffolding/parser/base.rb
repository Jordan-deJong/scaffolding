module Scaffolding
  module Parser
    class Base
      require 'rails'

      def initialize(file="")
        @errors = []
        @data = valid_data?(file)
        @file_name = File.basename(file, ".*" ).to_s.split.join.camelize
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

      def code_string
        process_data
        @scaffolding.each do |k, v|
          @code_string << " #{k}:#{v}"
        end
        @code_string
      end

      def data_types
        {string: 0, date: 0, integer: 0, boolean: 0, decimal: 0, time: 0, datetime: 0}
      end

      def self.process(file)
        importer = self.new(file)
        return importer.errors unless importer.errors.count == 0
        importer.code_string.to_s
      end

    end
  end
end
