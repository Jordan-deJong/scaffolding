module Scaffolding
  module Parser
    class Csv < Scaffolding::Parser::Base

      def initialize(file = "")
        super
        @headers = true
        @row_number = 0
      end

      def col_seperator
        seperators = {}
        [",","\t"].each {|seperator| seperators[seperator] = @data.count(seperator)}
        seperators.max_by{|k,v| v}[0]
      end

      def process_data(data = @data)
        CSV.parse(data, headers: @headers, col_sep: col_seperator, skip_blanks: true) do |row|
          setup_columns(row.to_h.keys) if @row_number == 0
          @row_number += 1
          begin
            process_row(row.inject({}){|row,(k,v)| row[k.downcase.to_sym] = v; row})
          rescue => e
            @errors << "Unable to process row #{@row_number} Error: #{e}\n"
          end
        end
        scaffold_rank
        @errors
      end

      def setup_columns(columns)
        columns.each do |column|
          @scaffolding[column.downcase.to_sym] = data_types
        end
      end

      def process_row(row)
        row.each do |column, data|
          data_type = :string
          data_type = :boolean if ["true", "false"].include?(data.to_s.downcase) rescue data_type
          data_type = :date if Date.parse(data) rescue data_type
          data_type = :time if Time.parse(data) rescue data_type
          data_type = :datetime if DateTime.parse(data) rescue data_type
          data_type = :integer if Integer(data) rescue data_type
          data_type = :decimal if ((data.to_f - data.to_i).abs > 0.0) rescue data_type
          @scaffolding[column.to_sym][data_type] += 1
        end
      end

      def scaffold_rank
        puts "\n\e[33mManually choose data types?(y/n)\e[0m"
        @manual = STDIN.gets.chomp

        @scaffolding.each do |scaffold, data_types|
          data_type = data_types.max_by{|k,v| v}[0]

          if @manual == "y"
            puts "\n\e[32m#{scaffold}\e[0m is a \e[33m#{data_type}\e[0m? (y/string/integer/date ect)"
            answer = STDIN.gets.chomp
            data_type = answer unless answer == "y"
          end

          @scaffolding[scaffold] = data_type
        end
      end

    end
  end
end
