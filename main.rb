#Sinatra Requirements
require 'sinatra'
require 'sinatra/reloader' if development?

#Template stuff requirements
require 'slim'
require 'sass'

# Settings
set :author, 'Ampelio Cherubini'
set :desc, 'Semplice app per la visualizzazione dei dati presenti nel db di Gnucash'
set :css, 'styles.css'
#Code Cleanup Helpers
helpers do

  def meta
    html="<meta charset=\"utf-8\" /><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, minimum-scale=1.0\"/>"
    html << "<meta name=\"description\"content=\"#{settings.desc}\"  />" if settings.desc
    html << "<meta name=\"author\" content=\"#{settings.author}\" />" if settings.author
  end

  def favicon
    "<link href=\"/favicon.ico\" rel=\"shortcut icon\" />"
  end

  def ie_shim
    "<!--[if lt IE 9]><script src=\"http://html5shiv.googlecode.com/svn/trunk/html5.js\"></script><![endif]-->"
  end

  def css(*stylesheets)
    stylesheets.map do |stylesheet|
      "<link href=\"/css/#{stylesheet}.css\" media =\"screen,projection\" rel=\"stylesheet\"/>"
    end.join
    end

  def js(*javascript)
    javascript.map do |javascript|
      "<script src=\"/js/#{javascript}.js\"</script>"
    end.join
  end

end



#Enabling Coffeescript for jQuery
require 'v8'
require 'coffee-script'
#JSON support
require 'json'
# Sequel ORM Classes
require './sequel_cfg'


#Routes 
#CSS Config with sass-scss
get('/css/styles.css'){ scss :styles }
#Coffeescript Config
get('/js/application.js'){ coffee :application }

#Main site routes
post '/vendors' do

end
get '/vendors' do
  #Seleziona tutti i venditori per nome
@vendors = Vendor.select(:name).order(:name).all
qryEntriesByVendor='select distinct `entries`.`description` AS `description`,(`entries`.`b_price_num` / `entries`.`b_price_denom`) AS `costo`,`vendors`.`name` AS `name` from ((`invoices` join `vendors` on((`invoices`.`owner_guid` = `vendors`.`guid`))) left join `entries` on((`entries`.`bill` = `invoices`.`guid`))) order by `entries`.`date` desc'
@ds = DB.fetch(qryEntriesByVendor)
slim :vendors
end

post '/vendors' do
  @vendorChoice =params(:vendor_choice)
end

get '/fatture' do
  slim :fatture
end

get '/inventory' do
  @vendors = Vendor.all
  @items = DB.fetch('select distinct `entries`.`description` AS `description`,
                    (`entries`.`b_price_num` / `entries`.`b_price_denom`) AS `costo`,
                     `vendors`.`name` AS `name`
                      from (
                      (`invoices` join `vendors`
                      on(
                          (`invoices`.`owner_guid` = `vendors`.`guid`)))
                         left join `entries`
                           on((`entries`.`bill` = `invoices`.`guid`)))
                               order by `entries`.`date` desc')
  slim :inventory
end

get '/' do 
  slim :home
end

get '/links' do
	slim :links
end

get '/rpi_setup' do
	slim :rpi_setup
end

not_found do
	slim :not_found
end
