module Tvrage
  
  class Tvshow
    
    attr_accessor :id, :name, :season_count, :seasons, :started, :ended, :link, :image, :country, :status, :classification, :genres, :runtime, :network, :air_time, :air_day, :timezone, :episodes
    
    def initialize(data)
      @id = data.xpath('showid').text.to_i
      @name = data.xpath('name').text
      @season_count = data.xpath('totalseasons').text.to_i
      @image = data.xpath('image').text
      @country = data.xpath('origin_country').text
      @link = data.xpath('link').text
      @status = data.xpath('status').text
      @classification = data.xpath('classification').text
      @runtime = data.xpath('runtime').text.to_i
      @network = data.xpath('network').text
      @air_day = data.xpath('air_day').text
      @timezone = data.xpath('timezone').text
      @link = data.xpath('showlink').text
      
      begin
        @air_time = Time.parse(data.xpath('airtime').text) if !data.xpath('airtime').text.empty?
      rescue Exception => e
        # invalid air time
      end
      
      @genres = data.xpath('genres/genre').map { |g| g.text } if data.xpath('genres/genre').length > 0
      @genres.reject! { |g| g.empty? } unless @genres.nil?
      
      begin
        @started = Date.parse(data.xpath('started').text) if !data.xpath('started').text.empty?
      rescue Exception => e
        # invalid start date
      end

      begin
        @ended = Date.parse(data.xpath('ended').text) if !data.xpath('ended').text.empty?
      rescue Exception => e
        # invalid end date
      end

      @episodes = data.xpath('Episodelist//Season/episode').map { |e| Episode.new(e, e.parent['no']) }
    end
        
  end
  
end