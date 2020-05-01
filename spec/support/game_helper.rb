# frozen_string_literal: true

module GameHelper
  def enter_game(sleep_timer: 0, locale: 'en', game_set_uid: nil)
    write_game_set_uid(game_set_uid) if game_set_uid
    visit root_path(locale: locale)
    sleep(sleep_timer)
    find('#start_button').click
  end

  def write_game_set_uid(game_set_uid)
    visit root_path
    create_cookie('tot_game_set', game_set_uid)
  end
end
