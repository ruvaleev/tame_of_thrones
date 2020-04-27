# frozen_string_literal: true

class KingdomsController < ApplicationController
  protect_from_forgery except: :index

  def preload; end

  def index
    find_all_kingdoms
    @allies_ids = Kingdom.find_by(name_en: 'Space').try(:vassals).try(:pluck, :id)
  end

  def reset_alliances
    Message.destroy_all
    Kingdom.all.update(sovereign_id: nil, ruler: false)
    render json: { head: :ok }
  end

  def reset_kingdoms
    ReinitializeKingdoms.run
    @allies_ids = []
    @space_kingdom_id = Kingdom.find_by(name_en: 'Space').id
    find_all_kingdoms
  end

  private

  def find_all_kingdoms
    @kingdoms = Kingdom.all
  end

  def receiver
    Kingdom.find(params[:receiver_id])
  end
end
