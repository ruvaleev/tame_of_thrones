@dialogueWindow =
  open: (elem) ->
    elem.click (e) ->
      receiver_id = elem.data('id')
      $('#dialogue').hide();
      $('#dialogue #receiver_id').val(receiver_id)
      $('#dialogue .avatar').html($(".kingdoms .king-avatar[data-id=#{receiver_id}]").clone())
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


      