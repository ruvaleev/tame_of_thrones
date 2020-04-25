ready = -> 
  pictureCircleCells(index) for index in [0..5]

  $('div.circle').mousedown (e) ->
    if $(this).hasClass('maximized')
      position = positionAtCircle(e)
      minimize_circle(this) if position.hypotenuse > position.circle_radius
    else
      maximize_circle(this)

  $(document).click (e) ->
    circle = document.getElementById('circle');
    minimize_circle(circle, false) if $(circle).has(e.target).length == 0

  $('.circle').on 'click', 'img.emblem', (e) ->
    openDialogue($(e.target).data('id'), $(e.target).data('index'), $(e.target).data('locale'))

  $('#messages_form').on 'submit', (e) ->
    sendMessage(e, $(this))

  $('div.circle').mousemove (e) ->
    cell_id = recognizeCell(e)
    unselectCircleCells('blue', 0, true)
    selectCircleCell(cell_id, 'blue', 0, true) if typeof(cell_id) != 'undefined'

  $('#reset_button').click () ->
    resetAllies()

  $('.tunes .sounds').click () ->
    toggleSounds()

  $('.tunes .music').click () ->
    toggleMusic()

  $('#reload_button').click () ->
    resetKingdoms()




  $('#rules').click (e) ->
    elem = document.getElementById('rules_modal');
    $('#rules_modal').fadeIn()
    closeByClick(elem)


$(document).on('turbolinks:load', ready)