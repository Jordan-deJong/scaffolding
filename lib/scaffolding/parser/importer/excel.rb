module Scaffolding
  module Parser
    module Importer
      class ExcelData < Scaffolding::Parser::Excel

        def process_row(row)
          row.each do |column, data|
            data_type = :string
            data_type = :date if Date.parse(data) rescue data_type
            data_type = :integer if Integer(data) rescue data_type
            @scaffolding[column.to_sym][data_type] += 1
          end
        end

      end
    end
  end
end
