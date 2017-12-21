require 'faker'

class Person
  attr_accessor :vname, :nname, :nick, :mail, :address, :number
  
  def initialize
#    @vname = Faker::Name.first_name 
#    @nname = Faker::Name.last_name
#    @nick = Faker::Pokemon.name
#    @mail = Faker::Internet.email
#    @address = Faker::Address.street_address + " in " + Faker::Address.city
#    @number = Faker::PhoneNumber.cell_phone
    @vname = "unknown"
    @nname = "unknown"
    @nick = "unknown"
    @mail = "unknown"
    @address = "unknown"
    @number = "unknown"
  end
  
  def name
    return @vname.to_s+" "+@nname.to_s
  end
end
