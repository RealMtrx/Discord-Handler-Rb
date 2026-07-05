require 'dotenv'

Dotenv.load

module Config
  TOKEN        = ENV.fetch('TOKEN')
  PREFIX       = ENV.fetch('PREFIX', '!')
  BOT_NAME     = ENV.fetch('BOT_NAME', 'Discord Handler')
  OWNER_ID     = ENV.fetch('OWNER_ID', nil)
  MONGO_URI    = ENV.fetch('MONGO_URI', 'mongodb://localhost:27017/discord-handler')
  ERROR_WEBHOOK   = ENV.fetch('ERROR_WEBHOOK', nil)
  GUILD_LOG_WEBHOOK = ENV.fetch('GUILD_LOG_WEBHOOK', nil)
end
