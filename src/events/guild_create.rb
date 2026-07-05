require_relative '../core/webhook_util'
require_relative '../config/config'

module GuildCreateEvent
  def self.execute(server)
    puts "\e[32m[GuildCreate] Joined: #{server.name} (#{server.id})\e[0m"
    WebhookUtil.send_webhook(
      Config::GUILD_LOG_WEBHOOK,
      "**Joined Server**\nName: #{server.name}\nID: #{server.id}\nMembers: #{server.member_count}"
    )
  end
end
