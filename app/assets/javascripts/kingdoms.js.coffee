ready = -> 
  $('.kingdoms .emblem-avatar').click () ->
    dialogueWindow.open($(this))


$(document).on('turbolinks:load', ready)