require 'net/http'
require 'json'

class AZUREPhotoAnalyzer
  def initialize(key)
    @uri = URI('https://westcentralus.api.cognitive.microsoft.com/vision/v2.0/analyze')
    @key = key
  end

  def tags(file_uri)
    response = analyze(file_uri)
    tags = JSON.parse(response.body)['description']['tags']
    hashtags = tags.map { |tag| '#' + tag }
    hashtags.join(', ')
  end

  def title(file_uri)
    response = analyze(file_uri)
    JSON.parse(response.body)['description']['captions'][0]['text']
  end

  def confidence(file_uri)
    response = analyze(file_uri)
    JSON.parse(response.body)['description']['captions'][0]['confidence']
  end

  def analyze(file_uri)
    set_query
    request = form_request(file_uri)
    send_request(request)
  end

  private

  def set_query
    @uri.query = URI.encode_www_form({
        'visualFeatures' => 'Categories, Description',
        'details' => 'Landmarks',
        'language' => 'en'
    })
  end

  def form_request(file_uri)
    request = Net::HTTP::Post.new(@uri.request_uri)
    request['Ocp-Apim-Subscription-Key'] = @key
    request['Content-Type'] = 'application/json'
    request.body = "{\"url\": \"#{file_uri}\"}"
    request
  end

  def send_request(request)
    Net::HTTP.start(@uri.host, @uri.port, :use_ssl => @uri.scheme == 'https') do |http|
      http.request(request)
    end
  end
end
