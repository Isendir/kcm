require 'sequel'

class Vendor < Sequel::Model

  set_dataset(:vendors)
  set_primary_key(:guid)

  #Associations
 #one_to_many :invoices, :key => :owner_guid
 #one_to_many :entries, :join => :invoices , :key => :guid

end