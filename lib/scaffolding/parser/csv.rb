module Scaffolding
  module Parser
    class Csv < Scaffolding::Parser::Base

      def groom_data
        @headers = true
        setup_columns
      end

      def setup_columns
        CSV.parse(@data, headers: @headers, col_sep: @col_seperator, skip_blanks: true).first.each do |column|
          @scaffolding[column[0].downcase.to_sym] = data_types
        end
      end

      def process_data(process_row)
        CSV.parse(@data, headers: @headers, col_sep: @col_seperator, skip_blanks: true) do |row|
          @row_number += 1
          begin
            self.send(process_row, row.inject({}){|row,(k,v)| row[k.downcase.to_sym] = v; row})
          rescue => e
            @errors << "Unable to process row #{@row_number} Error: #{e}\n"
          end
        end
      end

    end
  end
end
