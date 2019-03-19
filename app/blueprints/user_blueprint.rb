# frozen_string_literal: true

class UserBlueprint < Blueprinter::Base
  identifier :id

  view :create do
    fields :id
  end
end