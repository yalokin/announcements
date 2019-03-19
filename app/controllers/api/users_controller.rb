# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    def create
      user = User.create!
      json_response(user, status: :created)
    end
  end
end
