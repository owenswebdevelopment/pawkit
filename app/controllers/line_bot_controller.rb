class LineBotController < ApplicationController
  protect_from_forgery except: [:callback]
  skip_before_action :authenticate_user!, only: [:callback]

  def callback
    @parser ||= Line::Bot::V2::WebhookParser.new(channel_secret: ENV["CHANNEL_SECRET"])

    body = request.body.read
    signature = request.env["HTTP_X_LINE_SIGNATURE"]

    begin
      events = @parser.parse(body: body, signature: signature)

      events.each do |event|
        if event.source.type == "group"
          group_id = event.source.group_id
          Rails.logger.info "Group ID: #{group_id}" # Log the group ID
        end
      end
    rescue Line::Bot::V2::WebhookParser::InvalidSignatureError
      halt 400, { "Content-Type" => "text/plain" }, "Bad Request"
    end
  end



end
