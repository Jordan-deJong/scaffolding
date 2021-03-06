module Scaffolding
  module Parser
    class Raw < Scaffolding::Parser::Base

      def groom_data
        @data = @data.split("\n")
        @column_count = column_count
        bad_data
        find_headers
        setup_columns
        hashed_data
      end

      def column_count
        row_counts = []
        @data.map{ |row| row_counts << row.split(@col_seperator).count }
        row_counts.uniq.max_by{ |i| row_counts.count(i) }
      end

      def bad_data
        @data.delete_if {|row| row.split(@col_seperator).count != @column_count }
      end

      def find_headers
        first_row = @data.map.first.split(@col_seperator)
        @headers = first_row.map{ |header| header.strip.downcase.gsub(/(\W|\d)/, "") }
        @data.shift
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

      def process_data(process_row)
        @data.each do |row|
          @row_number += 1
          begin
            self.send(process_row, row)
          rescue => e
            @errors << "Unable to process row #{@row_number} Error: #{e}\n"
          end
        end
      end

    end
  end
end
