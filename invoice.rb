require 'sequel'

class Invoice < Sequel::Model
  set_dataset(:invoices)
  set_primary_key(:guid)

  #one_to_one :vendor, :key => :guid
  #many_to_one :entry, :key => :guid
end
