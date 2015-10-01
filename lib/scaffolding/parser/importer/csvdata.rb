module Scaffolding
  module Parser
    module Importer
      class CsvData < Scaffolding::Parser::Csv

        def process_row(row)
           "#{@file_name}".constantize.new(row).save
        end

        def scaffold_rank
        end

        def self.process(file)
          importer = self.new(file)
          return importer.errors unless importer.errors.count == 0
          importer.process_data
        end

      end
    end
  end
end
