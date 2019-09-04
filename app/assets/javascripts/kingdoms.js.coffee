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


$(document).on('turbolinks:load', ready)