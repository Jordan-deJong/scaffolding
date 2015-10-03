module Scaffolding
  module Parser
    class Base
      require 'rails'
      require 'csv'

      def initialize(file="")
        @errors = []
        @data = valid_data?(file)
        @file_name = File.basename(file, ".*" ).to_s.split.join.camelize.strip.singularize
        @scaffold_builder = @file_name
        @scaffolding = {}
      end

      def errors
        @errors
      end

      def valid_data?(file)
        unless file == ""
          # if [".csv", ".xls", ".xlsx"].include? File.extname(file)
          if File.extname(file) == ".csv"
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

      def data_types
        {string: 0, date: 0, integer: 0, boolean: 0, decimal: 0, time: 0, datetime: 0}
      end

      def col_seperator
        seperators = {}
        [",","\t"].each {|seperator| seperators[seperator] = @data.count(seperator)}
        seperators.max_by{|k,v| v}[0]
      end

      def self.process(file)
        importer = self.new(file)
        return importer.errors unless importer.errors.count == 0
        importer.process_data
      end

    end
  end
end
