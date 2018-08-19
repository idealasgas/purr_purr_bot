require_relative 'AZURE_photo_analyzer'
require 'yaml'

class PhotoHelper
  attr_reader :bot, :token
  KEY = YAML.load_file(File.join(Dir.pwd, 'config.yml'))['key']

  def initialize(bot, token)
    @bot = bot
    @token = token
  end

  def image_url
    bot.api.get_updates.dig('result',0,'message','photo',-1,'file_id')
    file_id = bot.api.get_updates.dig('result',0,'message','photo',-1,'file_id')
    file = bot.api.get_file(file_id: file_id)
    file_path = file.dig('result', 'file_path')
    return "https://api.telegram.org/file/bot#{token}/#{file_path}"
  end

  def user_pic_url(message)
    user_profile = bot.api.get_user_profile_photos(user_id: message.from.id)
    file_id = user_profile.dig('result','photos',0,0,'file_id')
    file = bot.api.get_file(file_id: file_id)
    file_path = file.dig('result', 'file_path')
    return "https://api.telegram.org/file/bot#{token}/#{file_path}"
  end

  def title(photo_url)
    AZUREPhotoAnalyzer.new(KEY).title(photo_url)
  end

  def tags(photo_url)
    AZUREPhotoAnalyzer.new(KEY).tags(photo_url)
  end

  def beauty(photo_url)
    confidence = AZUREPhotoAnalyzer.new(KEY).confidence(photo_url)
    return confidence > 0.5 ? 'beautiful' : 'ugly'
  end
end