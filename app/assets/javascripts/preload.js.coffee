
@load_application = (locale) ->
  $.ajax
    url: '/index',
    type: 'GET',
    beforeSend: (xhr) ->
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    data: {
      locale: locale
    }
    