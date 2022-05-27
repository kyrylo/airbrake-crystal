require "./spec_helper"

describe Airbrake::Config do
  describe "#uri" do
    id, key = 105138, "fd04e13d806a90f96614ad8e529b2822"

    it "returns the composed endpoint" do
      Airbrake.configure do |config|
        config.project_id  = id
        config.project_key = key
        config.endpoint    = "http://something.private.com:8080/"
      end

      uri = Airbrake.config.uri.to_s
      uri.should eq("http://something.private.com:8080/api/v3/projects/#{id}/notices?key=#{key}")
    end

    it "uses default values if not assigned" do
      Airbrake.configure do |config|
        config.project_id  = id
        config.project_key = key
      end

      uri = Airbrake.config.uri.to_s
      uri.should eq("https://app.airbrake.io/api/v3/projects/#{id}/notices?key=#{key}")
    end
  end
end
