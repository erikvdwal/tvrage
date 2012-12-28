module Tvrage
    
  class Client
    
    def search(query)
      response = get("/search.php?show=#{URI.escape(query)}")
      response.xpath('//Results/show').collect { |r| {
        'id'             => r.xpath('showid').text.to_i,
        'name'           => r.xpath('name').text,
        'country'        => r.xpath('country').text,
        'started'        => r.xpath('started').text.to_i,
        'ended'          => r.xpath('ended').text.to_i,
        'seasons'        => r.xpath('seasons').text.to_i,
        'status'         => r.xpath('status').text,
        'classification' => r.xpath('classification').text
      } }
    end
    
    def tvshow_by_id(tvshow_id, full_info = false)
      response = get("/full_show_info.php?sid=#{tvshow_id}")
      Tvshow.new(response.xpath('//Show').first) unless response.xpath('//Show/name').text.empty?
    end

    def updates_since(time)
      if time.is_a?(Date)
        time = time.to_time.to_i
      elsif time.is_a?(Time)
        time = time.to_time.to_i
      elsif !time.is_a?(Integer)
        raise "Incorrect time supplied. This needs to be either a Date, Time or Integer"
      end

      url = "/last_updates.php?"
      url << ((time < 1000) ? "hours=#{time}" : "since=#{time}")

      response = get(url)

      output = {}
      output['time'] = response.xpath("//updates").attr("at").text.to_i
      output['showing'] = response.xpath("//updates").attr("showing").text
      output['tvshows'] = response.xpath("//show/id").collect { |s| s.text.to_i }
      output
    end
    
    def base_url
      # "http://www.tvrage.com/feeds"
      "http://services.tvrage.com/feeds"
    end
    
private
    def get(uri)
      uri = URI.parse("#{base_url}#{uri}")
      response = Net::HTTP.get_response(uri)
      if response.code.to_i == 404
        raise RuntimeError, "The api returned status code #{response.code} for #{uri}"
      end
      
      Nokogiri::XML(response.body)
    end    
    
  end

end