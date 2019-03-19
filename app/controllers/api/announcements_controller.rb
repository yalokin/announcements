# frozen_string_literal: true

module Api
  class AnnouncementsController < ApplicationController
    before_action :authenticate
    before_action :set_announcement, only: [:show, :cancel]

    def index
      announcements = current_user.announcements
      json_response(announcements)
    end

    def create
      announcement = current_user.announcements.create!(announcement_params)
      json_response(announcement, status: :created)
    end

    def show
      view = current_user.author_of?(@announcement) ? :with_responses : :show
      json_response(@announcement, view: view)
    end

    def active
      announcements = Announcement.where(status: :active)
      json_response(announcements)
    end

    def cancel
      authorize!(@announcement)
      @announcement.cancel!
      json_response(@announcement)
    end

    private

    def announcement_params
      params.require(:announcement).permit(:id, :description, :status)
    end

    def set_announcement
      @announcement = Announcement.find(params[:id])
    end
  end
end