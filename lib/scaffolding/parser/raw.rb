module Scaffolding
  module Parser
    class Raw < Scaffolding::Parser::Base

      def initialize(file = "", auto)
        super
        @data = @data.split("\n")
      end

      def groom_data
        find_headers
        setup_columns
        hashed_data
      end

      def find_headers
        hc = header_count
        rows = 0
        @data.map do |row|
          rows += 1
          if row.split(@col_seperator).count == hc
            @headers = row.split(@col_seperator).map{ |header| header.strip.downcase.gsub(/(\W|\d)/, "") }
            rows.times{ @data.shift }
            return
          end
        end
      end

      def header_count
        row_counts = []
        @data.map{ |row| row_counts << row.split(@col_seperator).count }
        row_counts.uniq.max_by{ |i| row_counts.count(i) }
      end

      def setup_columns
        @headers.each{ |column| @scaffolding[column.to_sym] = data_types }
      end

      def hashed_data
        @data = @data.map do |row|
        fields  = row.split(@col_seperator)
        hash    = {}
        @headers.each_with_index do |header, index|
          hash[header] = fields[index].to_s.strip
        end
        hash
        end
      end

      def process_data
        @data.each do |row|
          @row_number += 1
          begin
            process_row(row)
          rescue => e
            @errors << "Unable to process row #{@row_number} Error: #{e}\n"
          end
        end
      end

    end
    
    raw_class = Class.new(Scaffolding::Parser::Raw) do; end
    Scaffolding::Parser.const_set("Dat", raw_class)
    Scaffolding::Parser.const_set("Txt", raw_class)
  end
end
