# frozen_string_literal: true

class AnnouncementBlueprint < Blueprinter::Base
  identifier :id

  view :common do
    field :user_id
    field :description
    field :created_at
    field :updated_at
    field :status
  end

  view :index do
    include_view :common
  end

  view :active do
    include_view :common
  end

  view :create do
    include_view :common
  end

  view :show do
    include_view :common
  end

  view :with_responses do
    include_view :common

    association :responses, blueprint: ResponseBlueprint, view: :show
  end

  view :cancel do
    field :id
  end
end