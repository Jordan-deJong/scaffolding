module Scaffolding
  module Parser
    module Importer
      class DatData < Scaffolding::Parser::Raw

        def initialize(file="", auto)
          super
          @saved = 0
          @failed = 0
        end

        def process_row(row)
           model = @source_name.classify.constantize.new(row.except!(:id))
           model.save ? @saved += 1 : @failed += 1
        end

        def results
          groom_data
          process_data
          return @errors unless @errors.count == 0
          {saved: @saved, failed: @failed}
        end

      end
    end
  end
end
