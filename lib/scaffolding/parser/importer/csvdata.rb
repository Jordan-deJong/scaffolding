module Scaffolding
  module Parser
    module Importer
      class CsvData < Scaffolding::Parser::Csv

        def process_row(row)
           "#{@file_name}".constantize.new(row).save
        end

        def scaffold_rank
        end

        def results
          true
        end

      end
    end
  end
end
