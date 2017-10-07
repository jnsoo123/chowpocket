class SemaphoreApi
  def initialize
    @apikey     = ENV['SEMAPHORE_API_KEY']
    @sendername = ENV['SEMAPHORE_SENDERNAME']
  end

  def send_message
    uri = Addressable::URI.new

    options = {
      apikey:     @apikey,
      number:     '639056671505',
      message:    'test',
      sendername: @sendername
    }

    binding.pry

    uri.query_values = options
    path = "http://api.semaphore.co/api/v4/messages?#{uri.query}"
    response = HTTP.post(path)

    print JSON.parse(response)
  end
end
