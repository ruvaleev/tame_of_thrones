ready = -> 
  $('body').on 'mousedown', 'div#circle', (e) ->
    if $(this).hasClass('maximized')
      position = positionAtCircle(e)
      minimize_circle(this) if position.hypotenuse > position.circle_radius
    else
      maximize_circle(this)

  $(document).click (e) ->
    circle = document.getElementById('circle');
    minimize_circle(circle, false) if $(circle).has(e.target).length == 0

  $('body').on 'click', '.circle img.emblem', (e) ->
    openDialogue($(e.target).data('id'), $(e.target).data('index'), $(e.target).data('locale'))

  $('body').on 'submit', '#messages_form', (e) ->
    sendMessage(e, $(this))

  $('body').on 'mousemove', 'div#circle', (e) ->
    cell_id = recognizeCell(e)
    unselectCircleCells('blue', 0, true)
    selectCircleCell(cell_id, 'blue', 0, true) if typeof(cell_id) != 'undefined'

  $('body').on 'click', '#reset_button', (e) ->
    game_set_id = $(e.target).data('game-set-id')
    resetAllies(game_set_id)

  $('body').on 'click', '#reload_button', (e) ->
    game_set_id = $(e.target).data('game-set-id')
    locale = $(e.target).data('locale')
    resetKingdoms(game_set_id, locale)

  $('body').on 'click', '.tunes .sounds', () ->
    toggleSounds()

  $('body').on 'click', '.tunes .music', () ->
    immediately = $(this).data('immediately')
    toggleMusic(immediately)

  $('body').on 'click', '.tunes_icon', () ->
    $('.lang_panel').slideToggle()
    setTimeout ->
      $('.lang_panel').slideToggle() if $('.lang_panel').is(':visible')
    ,6000

$(document).on('turbolinks:load', ready)