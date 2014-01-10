require './sequel_cfg'
require 'csv'


def formatted_number(n)
  #trovato su http://stackoverflow.com/questions/2597212/ruby-number-to-currency-displays-a-totally-wrong-number
  a,b = sprintf("%0.2f", n).split('.')
  a.gsub!(/(\d)(?=(\d{3})+(?!\d))/, '\\1,')
  "$#{a}.#{b}"
end

def currency_it(n)
  a,b = sprintf("%0.2f", n).split('.')
  a.gsub!(/(\d)(?=(\d{3})+(?!\d))/, '\\1.')
  "#{a},#{b}"
end


def createEntriesByVendorCSV()

  qryEntriesByVendor='select distinct `entries`.`description` AS `description`,(`entries`.`b_price_num` / `entries`.`b_price_denom`) AS `costo`,`vendors`.`name` AS `name` from ((`invoices` join `vendors` on((`invoices`.`owner_guid` = `vendors`.`guid`))) left join `entries` on((`entries`.`bill` = `invoices`.`guid`))) order by `entries`.`date` desc'
  vendorsByName = Vendor.select(:name).order.all
  ds =DB.fetch(qryEntriesByVendor)
  vendorsByName.each do |r|
    ds2 =ds.select(:description, :costo).from_self.where(:name => r[:name])
    CSV.open("csv/#{r[:name]}.csv", "w") do |csv|
      csv << ['Descrizione Articolo', 'Costo Unitario IVA ESCL.','Pezzi per Conf.','PrezzoPezzo','Qtà','Totale']
      ds2.each do |r|
        csv << [r[:description], currency_it(r[:costo].to_f)]
      end
    end
  end
end


def createListaFattureCSV()
  #dateSearchString ="2013-11-%"
  qryFatture =
      'SELECT vendors.name as Fornitore, DATE_FORMAT(invoices.date_opened,\'%d/%m/%Y\')
as Data_Fattura, invoices.id as Numero_Fattura FROM invoices JOIN
vendors ON invoices.owner_guid = vendors.guid order by invoices.date_opened'
  ds =DB.fetch(qryFatture)

    CSV.open("csv/ListaFatture_"  + Time.now.strftime("%Y%m%d") + ".csv", "w") do |csv|
      csv << ['Data Fattura', 'Numero Fattura','Fornitore']
      ds.each do |r|
        csv << [r[:Data_Fattura],r[:Numero_Fattura],r[:Fornitore]]
      end
    end

end

def prettyPrint(ds)
  ds.each do |r|
    p r
  end

  end



 min_date_opened = Invoice.min(:date_opened)
 max_date_opened = Invoice.max(:date_opened)



  p min_date_opened

  p max_date_opened


createListaFattureCSV

