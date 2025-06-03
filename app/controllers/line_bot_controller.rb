class LineBotController < ApplicationController
  skip_before_action :verify_authenticity_token # Required for webhook requests

  def callback
    body = request.body.read
    events = JSON.parse(body)["events"]

    events.each do |event|
      if event["source"]["type"] == "group"
        group_id = event["source"]["groupId"]
        Rails.logger.info "Group ID: #{group_id}" # Log the group ID
      end
    end






    render json: { status: 'success' }, status: :ok
  end
end
