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
        @source_name = clean_source_name
        @scaffolding = {}
        @row_number = 0
      end

      def errors
        @errors unless @errors.count == 0
      end

      def source_name
        @source_name
      end

      def clean_source_name
        name = (@name == "" ? File.basename(@source, ".*") : @name.dup)
        name.to_s.downcase.split.join.camelize.strip.singularize
      end

      def valid_data?
        if @source == "" || @source.nil?
          @errors << "No source selected"
          return false
        end
        @uri.nil? ? file : web
      end

      def web
        utf8_encode(`curl "#{@source}"`)
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

      def predict_row(row)
        row.each do |column, data|
          data_type = :string
          data_type = :boolean if ["true", "false"].include?(data.to_s.strip.gsub("\"","").downcase)
          data_type = :time if (data.to_s.strip.gsub("\"","").downcase =~ /^([01]?[0-9]|2[0-3])\:[0-5][0-9]?(:[0-6][0-9])?(am|pm)?$/) == 0
          data_type = :date if (data.to_s.strip.gsub("\"","") =~ /\A(?:0?[1-9]|[1-2]\d|3[01])\/(?:0?[1-9]|[1-2]\d|3[01])\/(?:\d{4}|\d{2})\Z/) == 0
          data_type = :datetime if (data.to_s.strip.gsub("\"","").downcase =~ /\A(?:\d{4}|\d{2})?(\/|-)?(?:0?[1-9]|[1-2]\d|3[01])?(\/|-)?(?:0?[1-9]|[1-2]\d|3[01])\s([01]?[0-9]|2[0-3])\:[0-5][0-9]?(:[0-6][0-9])?(am|pm)?\Z/
) == 0                                                                        
          data_type = :integer if Integer(data) rescue data_type
          data_type = :decimal if (data =~ (/[-]?\d*[,]?\d*[.]\d*[%]?$/)) == 0
          @scaffolding[column.to_sym][data_type] += 1 unless data == ""
        end
      end

      def save_row(row)
         model = @source_name.classify.constantize.new(row.except!(:id))
         model.save! ? @saved += 1 : @failed += 1
      end

      def scaffold_rank
        if @auto == nil
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
        scaffold = @source_name.dup
        @scaffolding.each do |k, v|
          scaffold << " #{k}:#{v}" unless k.to_s.downcase == "id"
        end
        scaffold
      end

      def results
        groom_data
        process_data "predict_row"
        errors
        scaffold_rank
        build_string
      end

      def import_data
        @saved = 0
        @failed = 0
        process_data "save_row"
        errors
        {saved: @saved, failed: @failed}
      end

    end
  end
end
