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
    
    #   receiver_id = elem.data('id')
    #   $.ajax
    #     url: '/begin_dialogue',
    #     type: 'GET',
    #     beforeSend: (xhr) -> 
    #       xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    #     data: {
    #       receiver_id: receiver_id
    #     }


      