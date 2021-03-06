class SemaphoreApi
  def initialize(object: nil)
    @object     = object
    @apikey     = ENV['SEMAPHORE_API_KEY']
    @sendername = ENV['SEMAPHORE_SENDERNAME']
  end

  def send_message
    message = create_message
    uri = Addressable::URI.new

    options = {
      apikey:     @apikey,
      number:     @object.number,
      message:    message,
      sendername: @sendername
    }

    uri.query_values = options
    path = "http://api.semaphore.co/api/v4/messages?#{uri.query}"
    response = HTTP.post(path)

    JSON.parse(response).all? {|r| r['status'] != 'failed'}
  end

  def send_number_verification_message(number, user)
    uri     = Addressable::URI.new
    options = {
      apikey:     @apikey,
      number:     number,
      message:    create_verification_message(user),
      sendername: @sendername 
    } 
    uri.query_values = options
    path = "http://api.semaphore.co/api/v4/messages?#{uri.query}"
    response = HTTP.post(path)

    JSON.parse(response).all? {|r| r['status'] != 'failed'}
  end

  private
  def create_verification_message(user)
    "Verification code: #{user.otp_code}."
  end

  def create_message
    message = "Hi #{@object.name}, thank you for your order with www.chowpocket.com.\n" +
              "Your order:\n" + 
              "#{@object.quantity} X #{@object.menu.name}\n" +
              "@ #{@object.building}\n" +
              "has been confirmed!\n" +
              "Delivery Window: 10AM - 12NN"
          
    message
  end
end
