require "./spec_helper"

describe Airbrake do
  describe "#notify" do
    id, key = 105138, "fd04e13d806a90f96614ad8e529b2822"

    Spec.before_each do
      Airbrake.configure do |config|
        config.project_id = id
        config.project_key = key
      end
    end

    it "sends notices" do
      WebMock.stub(:post, "https://app.airbrake.io/api/v3/projects/#{id}/notices?key=#{key}").
        to_return(body: %({"id":"1","url":"https://app.airbrake.io/locate/1"}))

      retval = Airbrake.notify(AirbrakeTestError.new)
      retval.should eq({"id" => "1", "url" => "https://app.airbrake.io/locate/1"})
    end

    it "raises error if project_key is missing" do
      Airbrake.config.project_key = nil

      expect_raises Airbrake::AirbrakeError, "both :project_id and :project_key are required" do
        Airbrake.notify(AirbrakeTestError.new)
      end
    end

    it "raises error if project_id is missing" do
      Airbrake.config.project_id = nil

      expect_raises Airbrake::AirbrakeError, "both :project_id and :project_key are required" do
        Airbrake.notify(AirbrakeTestError.new)
      end
    end
  end
end
