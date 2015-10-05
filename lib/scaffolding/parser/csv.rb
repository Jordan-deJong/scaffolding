module Scaffolding
  module Parser
    class Csv < Scaffolding::Parser::Base

      def initialize(file = "", auto)
        super
        @headers = true
        @row_number = 0
      end

      def setup_columns
        CSV.parse(@data, headers: @headers, col_sep: col_seperator, skip_blanks: true).first.each do |column|
          @scaffolding[column[0].downcase.to_sym] = data_types
        end
      end

      def process_data
        CSV.parse(@data, headers: @headers, col_sep: col_seperator, skip_blanks: true) do |row|
          @row_number += 1
          begin
            process_row(row.inject({}){|row,(k,v)| row[k.downcase.to_sym] = v; row})
          rescue => e
            @errors << "Unable to process row #{@row_number} Error: #{e}\n"
          end
        end
      end

      def scaffold_rank
        unless @auto
          puts "\n\e[33mManually choose data types?(y/n)\e[0m"
          manual = STDIN.gets.chomp
        end
        @scaffolding.each do |scaffold, data_types|
          data_type = data_types.max_by{|k,v| v}[0]
            unless @auto || manual != "y"
              puts "\n\e[32m#{scaffold}\e[0m is a \e[33m#{data_type}\e[0m? (y/string/integer/date ect)"
              answer = STDIN.gets.chomp.downcase
              data_type = answer unless answer == "y" || answer == ""
            end
          @scaffolding[scaffold] = data_type
        end
      end

      def results
        setup_columns
        process_data
        return @errors unless @errors.count == 0
        scaffold_rank
        @scaffolding.each do |k, v|
          @scaffold_builder << " #{k}:#{v}" unless k.to_s.downcase == "id"
        end
        @scaffold_builder
      end

    end
  end
end
