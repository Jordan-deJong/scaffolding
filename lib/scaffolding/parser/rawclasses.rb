raw_class = Class.new(Scaffolding::Parser::Raw) do
end
Scaffolding::Parser.const_set("Dat", raw_class)
Scaffolding::Parser.const_set("Txt", raw_class)
