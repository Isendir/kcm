require 'sequel'

class Entry < Sequel::Model
  set_dataset(:entries)
  set_primary_key(:guid)

  #one_to_one :invoice , :key => :bill



end
