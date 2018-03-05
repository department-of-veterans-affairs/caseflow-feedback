# frozen_string_literal: true

class HealthChecksController < ApplicationController

  def show
    render json: { healthy: true }.merge(Rails.application.config.build_version || {})
  end
end
