# frozen_string_literal: true

module GameHelper
  def enter_game(sleep_timer: 0, locale: 'en')
    visit root_path(locale: locale)
    sleep(sleep_timer)
    find('#start_button').click
  end
end
