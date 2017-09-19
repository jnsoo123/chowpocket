$(document).on('turbolinks:load', function() {
  $('#new_user').submit(function(){
    alert(1)
    return false
  })
})
