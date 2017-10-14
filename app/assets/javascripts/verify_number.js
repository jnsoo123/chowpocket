$(document).on('turbolinks:load', function(){
  if( $('form.edit-user').length != 0 ) {
    setUserVerification()
  }
})

function getUserId(){
  let form = $('form.edit-user')
  return form.attr('id').split('_').slice(-1).pop()
}

function setUserVerification(){
  let form = $('form.edit-user')

  form.on('submit', function(){
    if($('#verification_code').val() != ''){
      return true
    }

    if($('#user_phone_number').val() != ''){
      sendVerificationCode()
      setVerificationModal()
      return false
    }
  })
}

function setVerificationModal(){
  $('#verify-modal').modal('show')
  $('#submit-verification').click(function(){
    $('#verification_code').val($('#verification-code-modal').val())
    $('form.edit-user').submit()
  })
}

function sendVerificationCode() {
  let number = $('#user_phone_number').val()
  $.ajax({
    url: '/profiles/verify',
    method: 'GET',
    data: {
      number: number
    }
  })
}
