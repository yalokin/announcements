# frozen_string_literal: true

class Response < ApplicationRecord
  belongs_to :announcement, optional: true
  belongs_to :user

  validates_presence_of :price
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 100, less_than_or_equal_to: 10000 }
  validate :inactive_announcement, on: :create
  validate :check_declined, on: :create
  validate :check_pending, on: :create

  enum status: { pending: 0, cancelled: 1, declined: 2, accepted: 3 }

  def accept!
    transaction do
      update(status: :accepted)
      Response.where(announcement_id: announcement.id).where.not(id: id).update_all(status: :declined)
      announcement.update(status: :closed)
    end
  end

  def cancel!
    update(status: :cancelled)
  end

  private

  def inactive_announcement
    announcement.lock!
    errors.add(:status, I18n.t('error_messages.inactive_announcement')) unless announcement.active?
  end

  def check_declined
    errors.add(:status, I18n.t('error_messages.declined_response')) if have_declined_response?
  end

  def check_pending
    errors.add(:status, I18n.t('error_messages.pending_response')) if have_pending_response?
  end

  def have_declined_response?
    announcement.responses.where(user_id: user_id, status: :declined).present?
  end

  def have_pending_response?
    announcement.responses.where(user_id: user_id, status: :pending).present?
  end
end
