require 'telegram/bot'
require_relative 'AZURE_photo_analyzer'

token = '667909960:AAFYHWEOebfllCr_A9BnU70DgEBq2Yodjb0'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    if message.text
      user_profile = bot.api.get_user_profile_photos(user_id: message.from.id)
      file_id = user_profile.dig('result','photos',0,0,'file_id')
      file = bot.api.get_file(file_id: file_id)
      file_path = file.dig('result', 'file_path')
      photo_url = "https://api.telegram.org/file/bot#{token}/#{file_path}"
      title = AZUREPhotoAnalyzer.new('3af31fc8f4af4503975a8b05720a5228').title(photo_url)
      tags = AZUREPhotoAnalyzer.new('3af31fc8f4af4503975a8b05720a5228').tags(photo_url)
      confidence = AZUREPhotoAnalyzer.new('3af31fc8f4af4503975a8b05720a5228').confidence(photo_url)
      beauty = confidence > 0.5 ? 'beautyful' : 'ugly'
      bot.api.send_message(chat_id: message.chat.id, text: "You are #{beauty} on this photo")
      if tags.empty? 
        bot.api.send_message(chat_id: message.chat.id, text: "Sorry, I cannot find hashtags on this photo :(")
      else
        bot.api.send_message(chat_id: message.chat.id, text: "Hashtags for your instagram: #{tags}")
      end
      bot.api.send_message(chat_id: message.chat.id, text: "There is #{title} on this photo")
      bot.api.send_message(chat_id: message.chat.id, text: "Subscribe to Masha's Instagram: instagram.com/kontrolnetut")
      bot.api.send_message(chat_id: message.chat.id, text: "Subscribe to Sasha's Instagram: instagram.com/teslovskii")
    else 
      bot.api.send_message(chat_id: message.chat.id, text: "Subscribe to Masha's Instagram: instagram.com/kontrolnetut")
    end
  end
end


user_profile = bot.api.get_user_profile_photos(user_id: message.from.id)
file_id = user_profile.dig('result','photos',0,0,'file_id')
file = bot.api.get_file(file_id: file_id)
file_path = file.dig('result', 'file_path')
photo_url = "https://api.telegram.org/file/bot#{token}/#{file_path}"