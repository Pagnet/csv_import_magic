require 'orm_adapter/adapters/active_record'

ActiveSupport.on_load(:active_record) do
  extend CsvImportMagic::Models
end
