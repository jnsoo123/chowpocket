addEventListener 'turbolinks:load', (event) ->
  alert(1)
  if typeof ga is 'function'
    ga('set', 'location', event.data.url)
    ga('send', 'pageview')
