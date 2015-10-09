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
        beginning_time = Time.now

        row_counts = []
        @data.map{ |row| row_counts << row.split(@col_seperator).count }
        row_counts.uniq.max_by{ |i| row_counts.count(i) }

        end_time = Time.now
        puts "column_count #{(end_time - beginning_time)*1000} milliseconds"
      end

      def bad_data
        beginning_time = Time.now

        @data.delete_if {|row| row.split(@col_seperator).count != @column_count }

        end_time = Time.now
        puts "bad_data #{(end_time - beginning_time)*1000} milliseconds"
      end

      def find_headers
        beginning_time = Time.now
        puts @data
        first_row = @data.map.first.split(@col_seperator)
        @headers = first_row.map{ |header| header.strip.downcase.gsub(/(\W|\d)/, "") }
        @data.shift

        end_time = Time.now
        puts "find_headers #{(end_time - beginning_time)*1000} milliseconds"
      end

      def setup_columns
        beginning_time = Time.now

        @headers.each{ |column| @scaffolding[column.to_sym] = data_types }

        end_time = Time.now
        puts "setup_column #{(end_time - beginning_time)*1000} milliseconds"
      end

      def hashed_data
        beginning_time = Time.now

        @data = @data.map do |row|
          fields  = row.split(@col_seperator)
          hash    = {}
          @headers.each_with_index do |header, index|
            hash[header] = fields[index].to_s.strip
          end
          hash
        end

        end_time = Time.now
        puts "hashed_data #{(end_time - beginning_time)*1000} milliseconds"
      end

      def process_data(process_row)
        beginning_time = Time.now

        @data.each do |row|
          @row_number += 1
          begin
            self.send(process_row, row)
          rescue => e
            @errors << "Unable to process row #{@row_number} Error: #{e}\n"
          end
        end

        end_time = Time.now
        puts "#{process_row} #{(end_time - beginning_time)*1000} milliseconds"
      end

    end
  end
end
