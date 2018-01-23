# frozen_string_literal: true

module ApplicationHelper
  def use_fakes?
    Rails.env.development? || Rails.env.demo? || Rails.env.test?
  end
end
