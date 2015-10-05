module Scaffolding
  module Parser
    class Dat < Scaffolding::Parser::Base

      # def initialize(file = "", auto)
      #   super
      # end

      def process_data
        puts @data
        @results = @data.map do |row|
        fields  = row.split(col_seperator)
        hash    = {}
          @headers.each do |header, index|
            hash[header] = fields[index]
          end
          hash
        end
      end

      def results
        @results
      end

    end
  end
end
