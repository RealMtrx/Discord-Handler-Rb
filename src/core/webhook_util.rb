require 'net/http'
require 'json'
require 'uri'

module WebhookUtil
  def self.send_webhook(url, content, username: nil, avatar_url: nil)
    return if url.nil? || url.empty?

    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'

    payload = { content: content }
    payload[:username] = username if username
    payload[:avatar_url] = avatar_url if avatar_url

    request = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
    request.body = payload.to_json

    http.request(request)
  rescue StandardError => e
    puts "\e[31m[Webhook] Failed: #{e.message}\e[0m"
  end
end
