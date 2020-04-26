@openDialogue = (id, index, locale) ->
  unselectCircleCells('orange', 0)
  selectCircleCell(index, 'orange', 0)
  $('.avatar_in_center:visible, .title:visible, #chat').fadeOut(0)

  $.ajax
    url: '/greeting',
    type: 'GET',
    dataType: 'json',
    beforeSend: (xhr) -> 
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    data: {
      receiver_id: id,
      locale: locale
    }
    success: (response) ->
      $('.title .king').html(response.king)
      $('.title .name').html(response.translated_name)
      $('#chat').html("<p class='left orange'> #{response.message} </p>")
      $('#messages_form input[name="receiver_id"]').val(id)
      $("#king_avatar_#{id}, .title, #chat, div.form, #messages_form").fadeIn()
      $('.center_background:visible').fadeOut()


@sendMessage = (e, form, locale) ->
  e.preventDefault()
  e.stopPropagation()
  receiver_id = form.find('#receiver_id').val()
  sender_id = form.find('#sender_id').val()
  body = form.find('#body').val()
  form.find('#body').val('')
  $.ajax
    url: '/messages',
    type: 'POST',
    dataType: 'json',
    beforeSend: (xhr) -> 
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    data: {
      receiver_id: receiver_id,
      sender_id: sender_id,
      body: body,
      locale: form.find('#locale').val()
    }
    success: (response) ->
      $('#chat').append("<hr>")
      $('#chat').append("<p class='right white'>#{body}</p>")
      $('#chat').append("<hr>")
      $('#chat').append("<p class='left orange'>#{response.message}</p>")
      chat = document.getElementById('chat')
      chat.scrollTop = chat.scrollHeight
      index = findIndexFromId(receiver_id)

      if response.response == 'consent'
        audio.play('sounds/we_made_an_alliance.mp3')
        lightsOn(index, 'green', true)
        greetNewKing(response.kings_name, response.kingdoms_name) if response.new_king
      else
        lightsOn(index, 'red')
        audio.play('sounds/they_refused.mp3')

@findIndexFromId = (id) ->
  $("img.emblem[data-id=#{id}]").data('index')

@lightsOn = (index, color, leave_cell_on = false) ->
  selectCircleCell(index, color, 1000)
  $("##{color}_light_inner").fadeIn()
  $("##{color}_light_outer").fadeIn()
  setTimeout(lightsOff, 2000, index, color, leave_cell_on)

@lightsOff = (index, color, leave_cell_on) ->
  unselectCircleCells(color, 1000) if !leave_cell_on
  $("##{color}_light_inner").fadeOut()
  $("##{color}_light_outer").fadeOut()


@recognizeCell = (e) ->
  position = positionAtCircle(e)
  return if position.hypotenuse > position.circle_radius || position.hypotenuse < position.frame_radius
  # find sector of point
  arctangens = Math.atan(position.transformed_y / position.transformed_x)
  moduled_arctangens = Math.abs(arctangens)
  # Pi/3, radial angle of sector
  angle = 1.047

  if moduled_arctangens > angle
    return 0 if position.transformed_y < 0
    return 3 if position.transformed_y > 0
  else
    return 1 if position.transformed_y < 0 && position.transformed_x > 0
    return 2 if position.transformed_y > 0 && position.transformed_x > 0
    return 4 if position.transformed_y > 0 && position.transformed_x < 0
    return 5 if position.transformed_y < 0 && position.transformed_x < 0

@positionAtCircle = (e) ->
  x = e.pageX;
  y = e.pageY;
  center = findCircle()
  # transform coordinates to coordinates system with center at 0, 0
  transformed_y = y - center.center_y
  transformed_x = x - center.center_x
  # return if point is off the circle or too close to center
  central_frame = document.getElementById('central_frame')
  frame_radius = findWidth(central_frame)/2
  hypotenuse = Math.sqrt(transformed_y ** 2 + transformed_x ** 2)
  { 
    circle_radius: center.circle_radius,
    transformed_y: transformed_y,
    transformed_x: transformed_x,
    frame_radius: frame_radius,
    hypotenuse: hypotenuse
  }

@findCircle = () ->
  background = $('#circle_background')
  top_border = background.offset().top
  left_border = background.offset().left
  circle_height = background.height()
  circle_radius = circle_height/2
  {
    circle_radius: circle_radius,
    center_x: left_border + circle_radius,
    center_y: top_border + circle_radius
  }

@findWidth = (elem) ->
  getNumber(getComputedStyle(elem).width)

@findHeight = (elem) ->
  getNumber(getComputedStyle(elem).height)

@getNumber = (string) ->
  +/-?\d+/.exec(string)

@maximize_circle = (elem) ->
  return if $(elem).hasClass('maximized')
  elem.style.cursor = 'text'
  $(elem).addClass('maximized')
  $(elem).removeClass('minimized')
  document.getElementById('left_side').style.filter = 'blur(1px)'

@centerOn = (selector) ->
  $('html, body').animate({ scrollTop: $(selector).offset().top }, 1000)

@minimize_circle = (elem, scroll = true) ->
  return if !$(elem).hasClass('maximized')
  elem.style.cursor = 'pointer'
  $(elem).addClass('minimized')
  $(elem).removeClass('maximized')
  document.getElementById('left_side').style.filter = 'none'
  closeDialogue()

@unselectCircleCells = (color, duration, with_emblem = false) ->
  $("img.light_cell.highlighted_#{color}").fadeOut(duration)
  $("img.light_cell.highlighted_#{color}").removeClass("highlighted_#{color}")
  $(".emblem.highlighted_#{color}").width('14%') if with_emblem

@selectCircleCell = (cell_id, color, duration, with_emblem = false) ->
  $("img.light_cell_#{cell_id}.#{color}").fadeIn(duration)
  $("img.light_cell_#{cell_id}.#{color}, #circle_emblem_#{cell_id}").addClass("highlighted_#{color}")
  $("#circle_emblem_#{cell_id}").width('15%') if with_emblem

@pictureCircleCells = () ->
  pictureCells(index) for index in [0..5]

@pictureCells = (index) ->
  for color in ['blue', 'orange', 'red', 'green']
    kingdom_id = $("img.emblem[data-index=#{index}]").data('id')
    $("##{color}_light_cell").clone().attr({
                                            class: "light_cell light_cell_#{index} #{color}",
                                            'data-index': index,
                                            'data-id': kingdom_id
                                          }).appendTo('div#circle')
  
  selectCircleCell($(emblem).data('index'), 'green', 0) for emblem in $('#circle img.emblem[data-ally="true"]')

@resetAllies = () ->
  audio.play('sounds/gong.mp3')
  unselectCircleCells('green', 1000)
  closeDialogue()
  $.ajax
    url: '/reset_alliances',
    type: 'POST',
    dataType: 'json',
    beforeSend: (xhr) -> 
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))

@toggleSounds = () ->
  $('.sounds_on').toggle()
  $('.sounds_off').toggle()
    
@audio =
  play: (source) ->
    if $('body #sounds_on').is(':visible')
      audio = new Audio()
      audio.src = source
      audio.autoplay = true

@greetNewKing = (kings_name, kingdoms_name) ->
  $('p.congratulations.top').html($('p.congratulations.top').html().replace('%{kings_name}%', kings_name))
  $('p.congratulations.bottom').html($('p.congratulations.bottom').html().replace('%{kingdoms_name}%', kingdoms_name))
  $('p.congratulations.top').fadeIn()
  $('p.congratulations.bottom').fadeIn()
  frame = document.getElementById('central_frame')
  frame.style.zIndex = 105
  document.querySelector("body #music").pause()
  document.querySelector("body #final_music").play() if $('body #music_on').is(':visible')
  $('#throne_is_taken').fadeIn()
  elem = document.getElementById('throne_is_taken');
  closeByClick(elem)

@resetKingdoms = () ->
  audio.play('sounds/gong.mp3')
  unselectCircleCells('green', 1000)
  closeDialogue()
  $('.emblem, .avatar_in_center').addClass('inactive')
  $('img.circle').addClass('rotating')
  $.ajax
    url: '/reset_kingdoms',
    type: 'POST',
    beforeSend: (xhr) -> 
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))

@closeDialogue = () ->
  unselectCircleCells('orange', 1000)
  $('.avatar_in_center:visible, .title:visible, #chat, #messages_form').fadeOut()
  $('.center_background').fadeIn()



@toggleMusic = (turn_immediately) ->
  $('.music_on').toggle()
  $('.music_off').toggle()
  turnMusic() if turn_immediately

@turnMusic = () ->
  audio = document.querySelector("#music")
  if audio.paused
    audio.play()
  else
    audio.pause()

@closeByClick = (elem) ->
  $(window).on 'click', (e) ->
    if (e.target != elem)
      $('.congratulations').fadeOut()
      frame = document.getElementById('central_frame')
      frame.style.zIndex = 103
      document.querySelector("body #final_music").pause()
      document.querySelector("body #music").play() if $('body #music_on').is(':visible')

@finishRotating = () ->
  $('img.circle.rotating').removeClass('rotating').addClass('finish_rotating')
  setTimeout ->
    $('img.circle').removeClass('finish_rotating')
  ,1000
