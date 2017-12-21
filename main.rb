require 'sinatra'
# encoding: UTF-8
enable :sessions


set :bind, '0.0.0.0'

require_relative 'classes/Person'


before do
  @people = find_all
  for i in 1..50
    @people.push(Person.new())
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
  return []
end
