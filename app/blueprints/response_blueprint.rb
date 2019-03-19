# frozen_string_literal: true

class ResponseBlueprint < Blueprinter::Base
  identifier :id

  view :common do
    field :user_id
    field :announcement_id
    field :price
    field :status
  end

  view :index do
    include_view :common
  end

  view :create do
    include_view :common
  end

  view :show do
    include_view :common
  end

  view :accept do
    field :id
  end

  view :cancel do
    field :id
  end
end