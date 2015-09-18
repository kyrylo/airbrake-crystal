require "./spec_helper"

describe Airbrake::Config do
  describe "#uri" do
    id, key = 105138, "fd04e13d806a90f96614ad8e529b2822"

    it "returns the composed endpoint" do
      Airbrake.configure do |config|
        config.project_id  = id
        config.project_key = key
        config.host        = "something.private.com"
        config.port        = 8080
        config.secure      = false
      end

      uri = Airbrake.config.uri
      uri.should eq("http://something.private.com:8080/api/v3/projects/#{id}/notices?key=#{key}")
    end

    it "uses default values if not assigned" do
      Airbrake.configure do |config|
        config.project_id  = id
        config.project_key = key
      end

      uri = Airbrake.config.uri
      uri.should eq("https://airbrake.io/api/v3/projects/#{id}/notices?key=#{key}")
    end
  end
end
