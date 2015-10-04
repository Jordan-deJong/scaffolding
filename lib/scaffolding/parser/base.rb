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
        unless file == "" || file.nil?
          # if [".csv", ".xls", ".xlsx"].include? File.extname(file)
          if File.extname(file) == ".csv"
            File.read(utf8_encode(file))
          else
            @errors << "Unknown file type #{File.extname(file)} for #{file}"
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

      def process_row(row)
        row.each do |column, data|
          data_type = :string
          data_type = :boolean if ["true", "false"].include?(data.to_s.downcase) rescue data_type
          data_type = :date if Date.parse(Date.strptime(data, '%m/%d/%Y')) rescue data_type
          data_type = :time if Time.parse(Time.strptime(data, '%H:%M:%S')) rescue data_type
          data_type = :datetime if DateTime.parse(DateTime.strptime(data, '%m/%d/%Y %H:%M:%S')) rescue data_type
          data_type = :integer if Integer(data) rescue data_type
          data_type = :decimal if ((data.to_f - data.to_i).abs > 0.0) rescue data_type
          @scaffolding[column.to_sym][data_type] += 1 unless data == ""
        end
      end

      def self.process(file)
        importer = self.new(file)
        return importer.errors unless importer.errors.count == 0
        importer.results
      end

    end
  end
end
