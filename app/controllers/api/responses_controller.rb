# frozen_string_literal: true

module Api
  class ResponsesController < ApplicationController
    before_action :authenticate
    before_action :set_announcement, except: [:cancel, :index]
    before_action :set_response, only: [:cancel, :accept]

    def index
      responses = current_user.responses
      json_response(responses)
    end

    def create
      response = @announcement.responses.create!(response_params.merge(user_id: current_user.id))
      json_response(response, status: :created)
    end

    def accept
      authorize!(@announcement)
      @response.accept!
      json_response(@response)
    end

    def cancel
      authorize!(@response)
      @response.cancel!
      json_response(@response)
    end

    private

    def response_params
      params.require(:response).permit(:id, :announcement_id, :price, :status)
    end

    def set_response
      @response = Response.find(params[:id])
    end

    def set_announcement
      @announcement = Announcement.find(response_params[:announcement_id])
    end
  end
end
