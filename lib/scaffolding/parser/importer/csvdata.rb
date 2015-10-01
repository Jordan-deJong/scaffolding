module Scaffolding
  module Parser
    module Importer
      class CsvData < Scaffolding::Parser::Csv

        def initialize(file="")
          super
          @saved = 0
          @failed = 0
        end

        def process_row(row)
           model = "#{@file_name}".constantize.new(row)
           model.save ? @saved += 1 : @failed += 1
        end

        def scaffold_rank
        end

        def results
          {saved: @saved, failed: @failed}
        end

      end
    end
  end
end
