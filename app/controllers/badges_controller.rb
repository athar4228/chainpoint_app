# frozen_string_literal: true

class BadgesController < ApplicationController
  def new
    @badge = Badge.new
  end

  def create
    @badge = Badge.new(badge_params)
    if @badge.valid?
      @response = Actions::Badges::Submit.new(badge: @badge).call
      if @response.success?
        redirect_to success_badges_path(h: Base64.encode64(@response.response_details.to_json))
      else
        flash[:alert] = 'Something went wrong while making request to Chainpoint. Please contact administrator'
        redirect_to submit_badges_path
      end
    else
      render :new, error: @badge.errors.full_messages
    end
  end

  def success
    @hash_details = JsonParser.call(Base64.decode64(params[:h]))
    redirect_to submit_badges_path, alert: 'Please enter Badge details first' if @hash_details.blank?
  end

  private

  def badge_params
    params.fetch(:badge).permit(:issue_date, :name, :uuid)
  end
end
