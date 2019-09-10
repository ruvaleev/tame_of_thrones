ready = -> 
  
  $('.sounds_panel .music').click () ->
    toggleMusic()

  $('.sounds_panel .sounds').click () ->
    toggleSounds()

  $('.kingdoms').on 'click', '.emblem-avatar', () ->
    dialogueWindow.open($(this))

  $('#messages_form').on 'submit', (e) ->
    sendMessage(e, $(this))

  $('#allies_reset_button').click () ->
    resetAllies()

  $('#kingdoms_reset_button').click () ->
    resetKingdoms()

  $('#rules').click (e) ->
    elem = document.getElementById('rules_modal');
    $('#rules_modal').fadeIn()
    closeByClick(elem)
  

$(document).on('turbolinks:load', ready)