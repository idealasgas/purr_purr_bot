require 'telegram/bot'
require_relative 'message_helper'
require_relative 'photo_helper'
require 'yaml'

TOKEN = YAML.load_file(File.join(Dir.pwd, 'config.yml'))['token']

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    message_helper = MessageHelper.new(bot, message)
    if message_helper.not_a_photo?
      if message.text && message.text.match(/(?<=@).+/)
        p = PhotoHelper.new(bot, TOKEN)
        url = p.user_pic_url(message)
        bot.api.send_message(chat_id: message.chat.id, text: "You are #{p.beauty(url)} on this photo")
        if p.tags(url).empty? 
          bot.api.send_message(chat_id: message.chat.id, text: "Sorry, I cannot find hashtags on this photo :(")
        else
          bot.api.send_message(chat_id: message.chat.id, text: "Hashtags for your instagram: #{p.tags(url)}")
        end
        bot.api.send_message(chat_id: message.chat.id, text: "There is #{p.title(url)} on this photo")
        message_helper.subscribe_to_my_instagram
      else
        bot.api.send_message(chat_id: message.chat.id, text: "Please send me a photo or @username")
      end
    else
      photo_helper = PhotoHelper.new(bot, TOKEN)
      url = photo_helper.image_url
      bot.api.send_message(chat_id: message.chat.id, text: "You are #{photo_helper.beauty(url)} on this photo")
      if photo_helper.tags(url).empty? 
        bot.api.send_message(chat_id: message.chat.id, text: "Sorry, I cannot find hashtags on this photo :(")
      else
        bot.api.send_message(chat_id: message.chat.id, text: "Hashtags for your instagram: #{photo_helper.tags(url)}")
      end
      bot.api.send_message(chat_id: message.chat.id, text: "There is #{photo_helper.title(url)} on this photo")
      message_helper.subscribe_to_my_instagram
    end
  end
end


