class MessageHelper
  attr_reader :bot, :message
  def initialize(bot, message)
    @bot = bot
    @message = message
  end

  def not_a_photo?
    message.text || message.sticker || message.audio || message.document || message.game || message.video || message.voice || message.video_note || message.contact || message.venue
  end

  def subscribe_to_my_instagram
    bot.api.send_message(chat_id: message.chat.id, text: "Subscribe to Masha's Instagram: instagram.com/kontrolnetut")
    bot.api.send_message(chat_id: message.chat.id, text: "Subscribe to Sasha's Instagram: instagram.com/teslovskii")
  end

  def send_title(title)
    bot.api.send_message(chat_id: message.chat.id, text: "There is #{title} on this photo")
  end
end