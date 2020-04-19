# frozen_string_literal: true

class KingdomsController < ApplicationController
  around_action :switch_locale

  def index
    @kingdoms = Kingdom.all
    @allies = Kingdom.find_by(name: 'Space').try(:vassals)
  end

  def reset_alliances
    Message.destroy_all
    Kingdom.all.update(sovereign_id: nil, ruler: false)
    render json: { head: :ok }
  end

  def reset_kingdoms
    ReinitializeKingdoms.run
  end

  private

  def receiver
    Kingdom.find(params[:receiver_id])
  end

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end
