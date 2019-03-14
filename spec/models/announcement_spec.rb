require 'rails_helper'

RSpec.describe Announcement, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:responses).dependent(:destroy) }

  it { should validate_presence_of(:description) }
  it { should validate_length_of(:description).is_at_most(1000) }

  it { should define_enum_for(:status).with(active: 0, cancelled: 1, closed: 2) }
end
