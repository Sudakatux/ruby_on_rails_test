require 'open-uri'
class ParserController < ApplicationController
  
  def parse
	year = params[:year]
	month = params[:month]
	
	render :json => JSON.pretty_generate(run_parser(year,month))
	
  end
  
  def index
    render :json => JSON.pretty_generate(run_parser(2015,02))
  end
  
  
  private 
  
  def run_parser(year,month)
	options = []
	url = 'http://www.cadc.uscourts.gov/internet/opinions.nsf/OpinionsByRDate?OpenView&count=100&SKey='+year.to_s+month.to_s.rjust(2,"0")
	puts "Fetching for url "+url
	open(url) do |f|
		doc=Nokogiri::HTML(f)
		div_container=doc.xpath("//div[@id='ViewBody']")
		option={}
		div_container.xpath("//div[@class='row-entry']").each do |row|
				column_one_query="./span[1]/a"
				column_two_query="./span[2]"

				if row.children.count == 2

				        option={
						'opinion_number' => row.xpath(column_one_query).text,
   	 					'title' => row.xpath(column_two_query).text
					}
					
		
				elsif row.children.count == 3
					option['date']=row.xpath(column_two_query).text
					options << option
				end
		end

	end
	options
  end


end
