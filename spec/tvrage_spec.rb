require 'spec_helper'

describe Tvrage do
  before(:each) do
    @client = Tvrage::Client.new
  end
    
  describe "search" do
    it "should return results on valid search" do
      results = @client.search('Dexter')
      first = results.first
      first['id'].should == 7926
      first['name'].should == "Dexter"
      first['country'].should == "US"
      first['started'].should == 2006
    end
        
    it "should return no results on bogus search" do
      results = @client.search('lfkdsjksd')
      results.should be_empty
    end
  end
  
  describe "tvshow" do
    it "should return a valid tvshow" do
      result = @client.tvshow_by_id(7926)
      result.should be_a(Tvrage::Tvshow)
      result.id.should == 7926      
      result.name.should == "Dexter"
      result.country.should == "US"
      result.timezone == "GMT-5 -DST"
    end
      
    it "should have a bunch of episodes" do
      result = @client.tvshow_by_id(7926)
      result.episodes.map { |e| e.should be_a(Tvrage::Episode) }
      result.episodes.count.should > 0
      result.season_count > 0
    end    
    
    it "should not return a invalid tvshow" do
      result = @client.tvshow_by_id(4238902)
      result.should be_nil
    end    
  end
  
  describe "episode" do
    it "should be a valid episode" do
      result = @client.tvshow_by_id(7926)
      episode = result.episodes.first
      episode.should be_a(Tvrage::Episode)
      episode.title.should == "Dexter"
      episode.screencap == "http://images.tvrage.com/screencaps/40/7926/408409.jpg"
    end
  end

  describe "updates" do
    it "should return updates for the past 24 hours" do
      result = @client.updates_since(24)
      result['time'].should_not be_nil
      result['showing'].should eq "Last 24H"
      result['tvshows'].should_not be_empty
    end

    it "should return updates for the past 48 hours" do
      result = @client.updates_since(48)
      result['time'].should_not be_nil
      result['showing'].should eq "Last 2D"
      result['tvshows'].should_not be_empty
    end

    it "should return updates since last visit" do
      result = @client.updates_since(Time.now.to_i-14400) # 4 hours ago
      result['time'].should_not be_nil
      result['showing'].should eq "Last 24H"
      result['tvshows'].should_not be_empty
    end
  end
end