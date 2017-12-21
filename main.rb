require 'sinatra'
require 'net/ldap'
# encoding: UTF-8
enable :sessions


set :bind, '0.0.0.0'

require_relative 'classes/Person'


before do
  @people = find_all()
  if @people.size()==0
    for i in 1..2
      @people.push(Person.new())
    end
  end
  #sort by first name
  @people.sort!{|a,b| a.vname <=> b.vname}
end

get '/' do
  erb :index
end

post '/print' do
  
  redirect '/'
end

def find_all
  ldap = Net::LDAP.new(:host => "ldap1.mathphys.stura.uni-heidelberg.de", # your LDAP host name or IP goes here,
                      :port => "636", # your LDAP host port goes here,
                      :encryption => :simple_tls,
                      :base => "ou=People,dc=mathphys,dc=stura,dc=uni-heidelberg,dc=de", # the base of your AD tree goes here,
                      )
  search_filter = Net::LDAP::Filter.construct("(objectClass=*)")
  result_attrs = ["x-nickname",
                  "x-birthday",
                  "x-gender",
                  "x-jabber",
                  "x-department",
                  "x-spouse",
                  "cn",
                  "givenName",
                  "sn",
                  "Unread messages",
                  "jpegPhoto",
                  "mobile",
                  "homePhone",
                  "telephoneNumber",
                  "postalAddress",
                  "postalCode",
                  "title",
                  "c",
                  "l",
                  "st",
                  "street",
                  "description",
                  "uid",
                  "mail"
                ]
  ret = []
  puts "llll"
  ldap.search(:filter => search_filter, :attributes => result_attrs, :return_result => false) { |item| 
    p = Person.new()
    item.each do |k,v|
      if k.to_s == "givenName"
        p.vname = v
      end
      if k.to_s == "sn"
        p.nname = v[0]
      end
      if k.to_s == "uid"
        p.nick = v
      end
      if k.to_s == "mail"
        p.mail = v
      end
      if k.to_s == "postalAddress"
        p.address = v
      end
      if k.to_s == "mobile"
        p.number = v
      end
    end
    ret.push(p)
  }
  return ret
end
