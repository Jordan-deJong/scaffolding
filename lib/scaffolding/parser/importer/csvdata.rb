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
           model = @file_name.classify.constantize.new(row.except!(:id))
           model.save ? @saved += 1 : @failed += 1
        end

        def results
          process_data
          return @errors unless @errors.count == 0
          {saved: @saved, failed: @failed}
        end

      end
    end
  end
end
