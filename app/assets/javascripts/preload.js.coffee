@reset_player = (id, locale) ->
  $.ajax
    url: '/reset_player',
    type: 'POST',
    dataType: 'json',
    beforeSend: (xhr) ->
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    data: {
      id: id
      locale: locale
    }
    success: (response) ->
      $('.preload .form select').val(response.title)
      $('#player_leader').val(response.leader)
      $('#player_name').val(response.name)
      $('#reset_player').data('id', response.id)


@update_player = (locale) ->
  player_id = $('#reset_player').data('id')
  title = $('.preload .form select').val()
  leader = $('#player_leader').val()
  name = $('#player_name').val()
  $('.rules').html($('.rules').html().split('%{title}%').join(title).split('%{leader}%').join(leader).split('%{kingdom}%').join(name))
  $.ajax
    url: '/update',
    type: 'POST',
    beforeSend: (xhr) ->
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    data: {
      id: player_id,
      kingdom: {
        "title_#{locale}": title,
        "leader_#{locale}": leader,
        "name_#{locale}": name
      },
      locale: locale
    }

@load_application = (game_set_id, locale) ->
  $.ajax
    url: '/index',
    type: 'GET',
    beforeSend: (xhr) ->
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    data: {
      game_set_id: game_set_id,
      locale: locale
    }
    