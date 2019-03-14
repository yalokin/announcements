require 'rails_helper'

RSpec.describe Response, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:announcement) }

  it { should validate_presence_of(:price) }
  it { should validate_numericality_of(:price).only_integer }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(100) }
  it { should validate_numericality_of(:price).is_less_than_or_equal_to(10000) }

  it { should define_enum_for(:status).with(pending: 0, cancelled: 1, declined: 2, accepted: 3) }
end
