@dialogueWindow =
  open: (elem) ->
    receiver_id = elem.data('id')
    name = elem.data('name')
    king = elem.data('king')
    $('#dialogue').hide();
    $('#dialogue #receiver_id').val(receiver_id)
    $.ajax
      url: '/greeting',
      type: 'GET',
      dataType: 'json',
      beforeSend: (xhr) -> 
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      data: {
        receiver_id: receiver_id
      }
      success: (response) ->
        $('#dialogue #chat').html("<p class='right'>#{response.message}</p>")
        $('#dialogue .avatar').html($(".kingdoms .king-avatar[data-id=#{receiver_id}]").clone())
        $('#dialogue .avatar').prepend("<p>#{king} - the King of Kingdom #{name}</p>")
        $('#dialogue').fadeIn();
    
@audio =
  play: (source) ->
    if $('#sounds_on').is(':visible')
      audio = new Audio()
      audio.src = source
      audio.autoplay = true

@sendMessage = (e, form) ->
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
      body: body
    }
    success: (response) ->
      $('#dialogue #chat').append("<p class='left'>#{body}</p>")
      $('#dialogue #chat').append("<p class='right'>#{response.message}</p>")
      chat = document.getElementById('chat')
      chat.scrollTop = chat.scrollHeight

      if response.response == 'consent'
        audio.play('sounds/we_made_an_alliance.mp3')
        $("#allies [data-id=#{response.receiver_id}]").fadeIn()
        greetNewKing(response.kings_name, response.kingdoms_name) if response.new_king
      else
        audio.play('sounds/they_refused.mp3')

@greetNewKing = (kings_name, kingdoms_name) ->
  story = "<p>After a tense struggle King #{kings_name} have achieved decisive advantage. Now the enemies of the #{kingdoms_name} Kingdom have to bend the knees or to be destroyed</p>"
  $('#throne_is_taken .final_story').html(story)
  document.querySelector("#music").pause()
  document.querySelector("#final_music").play() if $('#music_on').is(':visible')
  $('#throne_is_taken').fadeIn()
  elem = document.getElementById('throne_is_taken');
  closeByClick(elem)
  $('.throne p').html("#{kings_name}<br>King of #{kingdoms_name}<br>is the Ruler")
  $('.throne #empty_throne').hide()
  $('.throne #throne').fadeIn()


@resetAllies = () ->
  audio.play('sounds/gong.mp3')
  $('#allies').hide()
  $.ajax
    url: '/reset_alliances',
    type: 'POST',
    dataType: 'json',
    beforeSend: (xhr) -> 
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    success: (response) ->
      $('#allies img').hide()
      $('#allies').fadeIn()
      resetThrone()

@resetKingdoms = () ->
  audio.play('sounds/gong.mp3')
  $('.kingdoms').hide()
  $('#dialogue').hide()
  $('#allies img').fadeOut()
  resetThrone()
  $.ajax
    url: '/reset_kingdoms',
    type: 'POST',
    beforeSend: (xhr) -> 
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))

@resetThrone = () ->
  $('.throne p').html('Throne is vacant')
  $('.throne #throne').hide()
  $('.throne #empty_throne').fadeIn()

@toggleMusic = () ->
  $('#music_on').toggle()
  $('#music_off').toggle()
  audio = document.querySelector("#music")
  if audio.paused
    audio.play()
  else
    audio.pause()

@toggleSounds = () ->
  $('#sounds_on').toggle()
  $('#sounds_off').toggle()

@closeByClick = (modal) ->
  window.onclick = (e) ->
    if (e.target == modal)
      modal.style.display = "none"
      document.querySelector("#final_music").pause()
      document.querySelector("#music").play() if $('#music_on').is(':visible')

@maximize_circle = (elem) ->
  elem.style.width = '62%';
  elem.style.marginTop = '0%';
  elem.style.marginLeft = '-30%';
  $(elem).data('minimized', false);
  document.getElementById('left_side').style.filter = 'blur(1px)';

@minimize_circle = (elem) ->
  elem.style.width = '54%';
  elem.style.marginTop = '4%';
  elem.style.marginLeft = '-6%';
  $(elem).data('minimized', true);
  document.getElementById('left_side').style.filter = 'none';
