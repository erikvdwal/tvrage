module Tvrage
  
  class Episode
    
    attr_accessor :season, :number, :product_number, :link, :title, :air_date, :screencap
    
    def initialize(data, season_number = 0)
      @season = season_number.to_i
      @number = data.xpath('seasonnum').text.to_i
      @product_number = data.xpath('prodnum').text
      @link = data.xpath('link').text
      @title = data.xpath('title').text
      @screencap = data.xpath('screencap').text if !data.xpath('screencap').text.empty?
      
      begin
        @air_date = Date.parse(data.xpath('airdate').text) if !data.xpath('airdate').text.empty?
      rescue Exception => e
        # air date is invalid
      end
      
    end
    
  end
  
end