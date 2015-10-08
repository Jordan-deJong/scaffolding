module Scaffolding
  module Parser
    class Base
      require 'rails'
      require 'csv'

      def initialize(source, name, auto, uri)
        @source, @name, @auto, @uri = source, name, auto, uri
        @errors = []
        return unless @data = valid_data?
        @col_seperator = col_seperator
        @source_name = source_name
        @scaffolding = {}
        @row_number = 0
      end

      def errors
        @errors
      end

      def source_name
        if @name  == ""
          name = File.basename(@source, ".*")
        else
          name = @name.dup
        end
        name.to_s.downcase.split.join.camelize.strip.singularize
      end

      def valid_data?
        if @source == "" || @source.nil?
          @errors << "No source selected"
          return false
        end
        @uri ? web : file
      end

      def web
        `curl "#{@source}"`
      end

      def file
        ext = File.extname(@source)
        if [".csv", ".dat", ".txt"].include? ext
          File.read(utf8_encode(@source))
        else
          @errors << "Unknown source type #{ext} for #{@source}"
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
          data_type = :date if Date.parse(Date.strptime(data, '%m/%d/%Y')) || Date.parse(Date.strptime(data, '%d/%m/%Y')) rescue data_type
          data_type = :time if Time.parse(Time.strptime(data, '%H:%M:%S')) rescue data_type
          data_type = :datetime if DateTime.parse(DateTime.strptime(data, '%m/%d/%Y %H:%M:%S')) || DateTime.parse(DateTime.strptime(data, '%d/%m/%Y %H:%M:%S')) rescue data_type
          data_type = :integer if Integer(data) rescue data_type
          data_type = :decimal if (data =~ (/[-]?\d*[,]?\d*[.]\d*[%]?$/)) == 0 rescue data_type
          @scaffolding[column.to_sym][data_type] += 1 unless data == ""
        end
      end

      def scaffold_rank
        unless @auto
          puts "\n\e[33mManually choose data types?(y/n) for #{@source_name}\e[0m"
          manual = STDIN.gets.chomp
        end
        @scaffolding.each do |scaffold, data_types|
          data_type = data_types.max_by{|k,v| v}[0]
            unless @auto || manual != "y"
              puts "\n\e[32m#{scaffold}\e[0m is a \e[33m#{data_type}\e[0m? ([Enter]/string/integer/date ect)"
              answer = STDIN.gets.chomp.downcase
              data_type = answer if data_types.keys.include?(answer.to_sym)
            end
          @scaffolding[scaffold] = data_type
        end
      end

      def build_string
        scaffold = @source_name
        @scaffolding.each do |k, v|
          scaffold << " #{k}:#{v}" unless k.to_s.downcase == "id"
        end
        scaffold
      end

      def results
        groom_data
        process_data
        return @errors unless @errors.count == 0
        scaffold_rank
        build_string
      end

      def self.process(source, name, auto, uri)
        importer = self.new(source, name, auto, uri)
        return importer.errors unless importer.errors.count == 0
        importer.results
      end

    end
  end
end
