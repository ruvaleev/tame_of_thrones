class Response
  attr_reader :sender, :receiver, :response

  def initialize(sender, receiver, response)
    @sender = sender
    @receiver = receiver
    @response = response
  end

  def send
    string = choose_response
    prepare_message(string)
  end

  private

  def choose_response
    file_path = choose_file_for_parsing(response)
    return if file_path.nil?

    File.read(file_path).split("\n").sample
  end

  def choose_file_for_parsing(response)
    {
      'consent' => 'public/uploads/alliance_consent_messages.txt',
      'refusal' => 'public/uploads/alliance_refusal_messages.txt'
    }[response]
  end

  def prepare_message(string)
    {
      receiver_name: receiver.name,
      receiver_king: receiver.king,
      sender_name: sender.name,
      sender_king: sender.king
    }.each { |key, value| string.gsub!("%{#{key}}%", value) }
    string
  end
end
