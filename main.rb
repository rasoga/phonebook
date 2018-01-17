require 'sinatra'
require 'net/ldap'

require "prawn"
require "prawn/measurement_extensions"
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
  #sort by first name and then last name
  @people.sort!{|a,b| (a.vname <=> b.vname).nonzero? || a.nname <=> b.nname}
end

get '/' do
  erb :index
end

get '/print' do
  # sets root as the parent-directory of the current file
  pub_path = File.join(File.dirname(__FILE__), 'public')
  #First push fixed Text to PDF without use of outside information
  @rows = 15
  @offset = 2
  pdf = Prawn::Document.new(:page_size => "A4") do 
    define_grid(:columns => 2, :rows => 15, :gutter => 5)
    stroke_color '000000'
    #grid.show_all
    
    font_families.update(
      "Comic Sans" => {
      :normal => "/usr/share/fonts/truetype/msttcorefonts/comicbd.ttf"
      }
    )
    font("Comic Sans", :size => 20)
    
    grid([0,0],[0,1]).bounding_box do
      #pdf.stroke_bounds
      pad_top(5){ indent(5){ text("Telefonliste MathPhysInfo",:align => :center, :size => 35) } }
      stroke_horizontal_rule
    end
    grid([1,0],[1,1]).bounding_box do
      #pdf.stroke_bounds
      pad_top(5){ indent(5){ text("Menschen ohne Nummer (im LDAP) werden nicht angezeigt!",:color => 'ff0000', :align => :center, :size => 15) } }
    end
    go_to_page 1
    #grid.show_all
  end
  
  @people.select!{|p| p.number != "unknown"}
  
  @people.each_with_index do |p,i|
    j = (i + @offset) % @rows
    puts(p.name,p.number,i,j)
    if j == 0 and i != 0
      #New Page
      pdf.start_new_page
    end
    
    #backgrounds
    if j%2 == 0
      pdf.grid([j,0], [j,1]).bounding_box do
        pdf.transparent(0.2) do
          pdf.stroke do
            pdf.fill_color '000000'
            pdf.fill_rectangle [pdf.cursor-pdf.bounds.height,pdf.cursor], pdf.bounds.width, pdf.bounds.height
            pdf.fill_color '000000'
          end
        end
      end
    end
  
    #pdf.grid([j,0],[j,1]).bounding_box do
    #  pdf.stroke_horizontal_rule
    #end
    pdf.grid([j,0],[j,0]).bounding_box do
      pdf.pad_top(5){ pdf.indent(5){ pdf.text p.name } }
    end
    pdf.grid([j,1],[j,1]).bounding_box do
      pdf.pad_top(5){
        pdf.indent(5){
          if p.number.kind_of?(Array)
            p.number.each do |o|
              pdf.text o
            end
          else
            pdf.text p.number 
          end
        }
      }
    end
  end
  
  filename = File.join(pub_path, "telefonliste.pdf")
  pdf.render_file filename
  send_file filename, :type => "application/pdf"
    
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
        p.nick = v[0]
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
    if p.nick != "unknown"
      ret.push(p)
    end
  }
  return ret
end
