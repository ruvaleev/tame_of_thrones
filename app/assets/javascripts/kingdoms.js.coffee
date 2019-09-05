ready = -> 
  $('.emblem-avatar').click () ->
    dialogueWindow.open($(this))

  $('#messages_form').on 'submit', (e) ->
    e.preventDefault()
    e.stopPropagation()
    receiver_id = $(this).find('#receiver_id').val()
    sender_id = $(this).find('#sender_id').val()
    body = $(this).find('#body').val()
    $(this).find('#body').val('')
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
        else
          audio.play('sounds/they_refused.mp3')

  $('#reset_button').click () ->
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
    

$(document).on('turbolinks:load', ready)