["Csv" => "Csv", "Txt" => "Raw", "Dat" => "Raw"].each do |type, parent|
  new_class = Class.new("Scaffolding::Parser::#{parent}".constantize) do
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

  "Scaffolding::Parser::Importer".constantize.const_set("#{type}Data", new_class)
end
