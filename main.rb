require 'sinatra'
# encoding: UTF-8
enable :sessions


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

get '/printpdf' do
  content = File.open("views/content.tex", 'w')
  #fill content
  @people.each do |p|
    content << "\\entry{#{p.name}}{#{p.nick}}{#{p.number}}{#{p.mail}}"
  end
  #close file
  content.close()
  
  #set path for pdflatex and execute
  layoutPath = File.expand_path(File.dirname(__FILE__)).to_s + "/views"
  system("cd #{layoutPath} && pdflatex #{layoutPath}/layout.tex > /dev/null && mv layout.pdf list.pdf")
  
  #download file
  send_file(File.open("views/list.pdf"), :disposition => 'attachment')
  
  redirect '/'
end

def find_all
  return []
end
