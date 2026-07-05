require_relative '../handlers/logger'

module ReadyEvent
  def self.execute(bot, bot_name)
    bot.update_status('online', "with #{bot_name}", nil, nil, 0, false)
    puts "\e[32m[Ready] Logged in as #{bot.profile.username}##{bot.profile.discriminator}\e[0m"
  end
end
