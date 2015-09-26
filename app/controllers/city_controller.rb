class CityController < ApplicationController
  require 'rest_client'
  require 'json'
  require 'addressable/uri'



  def show
  	city_hash = {"Atlanta"=>"atlanta", "Austin"=>"austin", "Boston"=>"boston", "Chicago"=>"chicago", "Charlotte"=>"charlotte", "Dallas"=>"dallas", "Denver"=>"denver", "Houston"=>"houston", "Kansas City"=>"kansascity", "Las Vegas"=>"lasvegas", "Los Angeles"=>"losangeles", "Miami"=>"miami", "Minneapolis"=>"minneapolis", "Nashville"=>"nashville", "New York"=>"newyork", "Phoenix"=>"phoenix", "portland"=>"portland", "Raleigh"=>"raleigh", "St Louis"=>"stlouis", "San Diego"=>"sandiego", "San Francisco"=>"sfbay", "Seattle"=>"seattle", "Washington DC"=>"washingtondc"}
    @city = city_hash[params[:id]]
  end



  def search
  	case params[:editor]
    when "chinoiserie"
      search1 = 'categories/vintage/antique/furniture&keywords="chinoiserie"'
    when "mid century"
      search1 = 'categories/vintage/antique/furniture&keywords="mid century"'
    when "hollywood_regency"
      search1 = 'categories/vintage/antique/furniture&keywords="hollywood regency"'
    when "outdoor_furniture"
      search1 = 'categories/vintage/antique/furniture&keywords="outdoor furniture"'
    when "dressers"
      search1 = 'categories/vintage/antique/furniture&keywords="dressers"'
    when "sofas"
      search1 = 'categories/vintage/antique/furniture&keywords="sofas"'
    when "desks"
       search1 = 'categories/vintage/antique/furniture&keywords="desks"'
    when "nursery_furniture"
      search1 = 'categories/vintage/antique/furniture&keywords="nursery"'
    when "mirrors"
      search1 = 'categories/vintage/antique/housewares&keywords="vintage mirror"'
    when "rattan"
       search1 = 'categories/vintage/antique/furniture&keywords="rattan"'
    when "side_tables"
       search1 = 'categories/vintage/antique/furniture&keywords="side tables"'
    when "lamps"
       search1 = 'categories/housewares/lighting&keywords="vintage lamps"'
    when "dining_chairs"
       search1 = 'categories/vintage/antique/furniture&keywords="dining chairs"'
     when "coffee_table"
       search1 = 'categories/vintage/antique/furniture&keywords="coffee tables"'
    when "lounge_chairs"
       search1 = 'categories/vintage/antique/furniture&keywords="lounge chairs"'
    else
      
    end

    @listings = []
    @listing_ids = []
    @listing_info = {}
    @array = []
    @results ={}
    @hash = {}
    
    
    
    city_hash = {"Atlanta"=>"4180439", "Austin"=>"4671654", "Boston"=>"4930956", "Chicago"=>"4887398", "Charlotte"=>"4460243", "Dallas"=>"4684888", "Denver"=>"5419384", "Houston"=>"4699066", "Kansas City"=>"4393217", "Las Vegas"=>"5506956", "Los Angeles"=>"5368361,5376890,5367929", "Miami"=>"4164138,4177887,4155966", "Minneapolis"=>"5037649", "Nashville"=>"4644585", "New York"=>"5128581,5101760,5125125,", "Phoenix"=>"5308655,5313457", "portland"=>"5746545", "Raleigh"=>"4487042", "St Louis"=>"4407066", "San Diego"=>"5391811,5363943", "San Francisco"=>"5391959,5392171,5378538", "Seattle"=>"5809844", "Washington DC"=>"4140963"}
    @city = city_hash[params[:city]]
    
    url = "https://openapi.etsy.com/v2/listings/active?#{search1}&location=#{@city}&fields=listing_id&limit=50&api_key=73nugzwvzagme29vrv97pxf0"
    
    parsed_query = Addressable::URI.parse(url).normalize.to_str
    
    
    response = RestClient::Request.execute(method: :get, url: parsed_query)
    @parsed = JSON.parse(response)
    @listings = @parsed["results"]
    

    @listings.each do |listing|
      @listing_ids<<listing['listing_id']
    end
    
    
    

 

    #parse the results
    @listing_ids.each do |listing_id|
      
      @listing_id = listing_id
      url_2 = "https://openapi.etsy.com/v2/listings/#{@listing_id}?fields=title,price,url&api_key=73nugzwvzagme29vrv97pxf0"
      sleep(0.5)
      parsed_query_2 = Addressable::URI.parse(url_2).normalize.to_str
      response_2 = RestClient::Request.execute(method: :get, url: parsed_query_2)
      @parsed = JSON.parse(response_2)
      @listing_info = @parsed['results']
      @hash = @listing_info[0]

      @title = @hash['title']
      @url =   @hash['url']
      @price = @hash['price']
      url_3 = "https://openapi.etsy.com/v2/listings/#{listing_id}/images?method-GET&api_key=73nugzwvzagme29vrv97pxf0"
      parsed_query_3 = Addressable::URI.parse(url_3).normalize.to_str
      sleep(0.5)
      response_3 = RestClient::Request.execute(method: :get, url: parsed_query_3)
      @parsed = JSON.parse(response_3)
      @images = @parsed['results']
      @hash = @images[0]
      @image = @hash['url_170x135'] 
      
    
      

      
      
      

      #save the results
      @results = {"title" => @title, "url" => @url, "price" => @price, "image" => @image}
    
    
    @array << @results.dup
    end
    
    
  editor_hash = {"dining_chairs"=>"Dining Chairs", "dressers"=>"Dressers", "sofas"=>"Sofas", "lamps"=>"Lighting", "side_tables"=>"Side Tables", "daybeds"=>"Daybeds / Benches", "rattan"=>"Rattan Furniture", "outdoor_furniture"=>"Outdoor Furniture", "desks"=>"Desks", "coffee_table"=>"Coffee Tables", "mirrors"=>"Mirrors", "hollywood_regency"=>"Hollywood Regency", "lounge_chairs"=>"Lounge Chairs"}
  @title = editor_hash[params[:editor]]
  end
end
