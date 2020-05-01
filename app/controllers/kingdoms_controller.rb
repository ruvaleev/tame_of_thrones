# frozen_string_literal: true

class KingdomsController < ApplicationController
  protect_from_forgery except: :update

  before_action :find_game_set, except: :update

  def update
    @kingdom = Kingdom.find(params[:id])
    @kingdom.update(kingdoms_params)
  end

  def reset_alliances
    @game_set.player.sent_messages.destroy_all
    @game_set.kingdoms.update(sovereign_id: nil, ruler: false)
    render json: { head: :ok }
  end

  def reset_kingdoms
    @game_set.player.sent_messages.destroy_all
    @game_set.game_kingdoms.destroy_all
    @game_set.create_game_kingdoms
    @kingdoms = @game_set.game_kingdoms
    @allies_ids = []
  end

  private

  def find_game_set
    @game_set = GameSet.find(params[:id])
  end

  def kingdoms_params
    params.require(:kingdom).permit(:name_en, :name_ru, :title_en, :title_ru, :leader_en, :leader_ru)
  end
end
