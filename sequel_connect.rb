require 'sequel'
# Connessione al database
DB = Sequel.connect('mysql://ampi:ampi@192.168.0.31:3306/gnucash_kicco_s_cafe')
#Creazione di un log SQL in sequel.log
DB.logger = Logger.new('sequel.log')