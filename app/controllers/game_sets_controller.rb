# frozen_string_literal: true

class GameSetsController < ApplicationController
  protect_from_forgery except: :index

  before_action :find_or_create_game_set
  before_action :find_or_create_player, except: :reset_player

  def preload
    @game_set.create_game_kingdoms
    cookies[:tot_game_set] = @game_set.uid
  end

  def index
    @kingdoms = @game_set.game_kingdoms
    @allies_ids = @player.vassals.pluck(:id)
  end

  def reset_player
    @game_set.player.destroy && @game_set.reload
    find_or_create_player
    render json: { id: @player.id,
                   title: @player.title,
                   leader: @player.leader,
                   name: @player.name }
  end

  private

  def find_or_create_game_set
    @game_set = params[:game_set_id] ? GameSet.find(params[:game_set_id]) : find_by_cookie_or_create
  end

  def find_or_create_player
    @player = @game_set.player || CreateKingdom.new(@game_set.id, true).run
  end

  def find_by_cookie_or_create
    uid = cookies[:tot_game_set]
    @game_set = uid.nil? ? GameSet.create(uid: SecureRandom.hex) : GameSet.find_by(uid: uid)
  end
end
