# frozen_string_literal: true

class ApplicationController < ActionController::API
  class NotAuthorized < StandardError; end

  include JsonResponse
  include ExceptionHandler

  def authenticate
    if User.find_by(id: request.headers['USER-ID'])
      session[:user_id] ||= request.headers['USER-ID']
    else
      render json: { message: I18n.t('status_messages.unathorized') }, status: :unauthorized
    end
  end

  def current_user
    return unless session[:user_id]
    current_user ||= User.find(session[:user_id])
  end

  def authorize!(resource)
    raise NotAuthorized, I18n.t('status_messages.access_denied') unless current_user.author_of?(resource)
  end
end
