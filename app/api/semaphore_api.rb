class SemaphoreApi
  def initialize(number: nil)
    @number     = number
    @apikey     = ENV['SEMAPHORE_API_KEY']
    @sendername = ENV['SEMAPHORE_SENDERNAME']
  end

  def send_message(message)
    uri = Addressable::URI.new

    options = {
      apikey:     @apikey,
      number:     @number,
      message:    message,
      sendername: @sendername
    }

    uri.query_values = options
    path = "http://api.semaphore.co/api/v4/messages?#{uri.query}"
    response = HTTP.post(path)

    JSON.parse(response).all? {|r| r['status'] != 'failed'}
  end
end
