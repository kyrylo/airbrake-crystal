require "json"
require "http/client"

require "./airbrake/*"

module Airbrake
  module Backtrace
    # Examples:
    #   *raise<String>:NoReturn +70 [0]
    #   *Crystal::CodeGenVisitor#visit<Crystal::CodeGenVisitor, Crystal::Assign>:(Nil | Bool) +534 [0]
    STACKFRAME_TEMPLATE = /\A(.+)? \+(\d+)/

    def self.parse(exception)
      (exception.backtrace || [] of String).map do |stackframe|
        if m = stackframe.match(STACKFRAME_TEMPLATE)
          { file: m[1]? || "<crystal>" , line: m[2]?.try(&.to_i) || 0, function: "<file>" }
        else
          { file: "<crystal>", line: 0, function: "<file>" }
        end
      end
    end
  end

  class Notice
    def initialize(exception)
      @payload = {
        notifier: {
          name: "Airbrake Crystal"
          version: Airbrake::VERSION,
          url: "https://github.com/kyrylo/airbrake-crystal"
        },
        errors: [{ type: exception.class.name,
                   message: exception.message,
                   backtrace: Backtrace.parse(exception) }],
        context: {
          os: {{`uname -a`.stringify}},
          language: {{`crystal -v`.stringify}}
        },
        environment: {} of Symbol => Hash(String, String),
        params: {} of String => Hash(String, String)
      }
    end

    def to_json(io)
      @payload.to_json(io)
    end
  end

  class Config
    property :project_id
    property :project_key
    property :host
    property :port
    property :secure

    def uri
      self.host   ||= "airbrake.io"
      self.port   ||= 443
      scheme = (self.secure.nil? || self.secure) ? "https" : "http"

      URI.new(scheme, host, port, "/api/v3/projects/#{project_id}/notices", "key=#{project_key}").to_s
    end
  end

  module Sender
    def self.send(notice)
      response = HTTP::Client.post(
        Airbrake.config.uri,
        headers: HTTP::Headers{ "Content-Type" => "application/json",
                                "User-Agent" => "Airbrake Crystal" },
        body: notice.to_json)

      Hash(String, String).from_json(response.body)
    end
  end

  class AirbrakeError < Exception
  end

  def self.notify(exception)
    unless [config.project_id, config.project_key].all?
      raise AirbrakeError.new("both :project_id and :project_key are required")
    end

    send_payload(build_notice(exception))
  end

  def self.build_notice(exception)
    Notice.new(exception)
  end

  def self.send_payload(notice)
    Sender.send(notice)
  end

  def self.configure
    @@configuration = Config.new
    yield config
  end

  def self.config
    @@configuration ||= Config.new
  end
end
