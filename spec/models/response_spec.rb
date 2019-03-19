# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Response, type: :model do
  let(:user) { create(:user) }
  let(:active_announcement) { create(:announcement, status: :active) }
  let(:closed_announcement) { create(:announcement, status: :closed) }
  let(:declined_response) { create(:response, announcement: active_announcement, user: user, status: :declined) }
  let(:pending_response) { create(:response, announcement: active_announcement, user: user, status: :pending) }

  subject { described_class.new(announcement: active_announcement, user: user, price: 1500) }

  it { should belong_to(:user) }
  it { should belong_to(:announcement) }

  it { should validate_presence_of(:price) }
  it { should validate_numericality_of(:price).only_integer }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(100) }
  it { should validate_numericality_of(:price).is_less_than_or_equal_to(10000) }

  it { should define_enum_for(:status).with(pending: 0, cancelled: 1, declined: 2, accepted: 3) }

  context 'custom validations' do
    it "should validate that can only response to an active announcement" do
      subject.valid?
      subject.errors[:status].should be_empty

      subject.announcement = closed_announcement
      subject.valid?
      subject.errors[:status].should include(I18n.t('error_messages.inactive_announcement'))
    end

    it "should validate that have not declined response" do
      declined_response
      subject.valid?
      subject.errors[:status].should include(I18n.t('error_messages.declined_response'))
    end

    it "should validate that have not pending responses" do
      pending_response
      subject.valid?
      subject.errors[:status].should include(I18n.t('error_messages.pending_response'))
    end
  end
end
