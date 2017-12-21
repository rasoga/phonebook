require 'sinatra'

set :bind, '0.0.0.0'

require_relative 'classes/Person'

get '/' do
  @people = []
  for i in 1..50
    @people.push(Person.new())
  end
  erb :index
end

post '/print' do
  
  redirect '/'
end
