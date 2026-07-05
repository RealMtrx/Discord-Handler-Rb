require_relative '../core/webhook_util'
require_relative '../config/config'

module GuildDeleteEvent
  def self.execute(server)
    puts "\e[31m[GuildDelete] Left: #{server.name} (#{server.id})\e[0m"
    WebhookUtil.send_webhook(
      Config::GUILD_LOG_WEBHOOK,
      "**Left Server**\nName: #{server.name}\nID: #{server.id}"
    )
  end
end
