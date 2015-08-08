require "spec"
require "webmock"
require "../src/airbrake"

Spec.before_each &->WebMock.reset

class AirbrakeTestError < Exception
  def backtrace
    [ "*Exception@Exception#initialize<JSON::ParseException, String>:Array(String) +31 [0]",
      "*JSON::ParseException#initialize<JSON::ParseException, String, Int32, Int32>:Array(String) +129 [0]",
      "*JSON::ParseException::new<String, Int32, Int32>:JSON::ParseException +113 [0]",
      "*JSON::PullParser#parse_exception<JSON::PullParser, String>:NoReturn +65 [0]",
      "*JSON::PullParser#expect_kind<JSON::PullParser, Symbol>:Nil +110 [0]",
      "*JSON::PullParser#read_begin_array<JSON::PullParser>:Symbol +15 [0]",
      "*Array(String)::new<Array(String):Class, JSON::PullParser>:Array(String) +55 [0]",
      "*Array(String)::from_json<Array(String):Class, String>:Array(String) +40 [0]",
      "*Airbrake::Sender::send<Airbrake::Notice>:Array(String) +195 [0]",
      "*Airbrake::send_payload<Airbrake::Notice>:Array(String) +6 [0]",
      "*Airbrake::notify<AirbrakeTestError>:Array(String) +14 [0]",
      "__crystal_main +26232 [0]",
      "main +108 [0]",
      "__libc_start_main +240 [0]",
      "_start +41 [0]",
      "+41 [0]" ]
  end

  def message
    "App crashed!"
  end
end
