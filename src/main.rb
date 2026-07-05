require 'discordrb'

require_relative 'config/config'
require_relative 'events/ready'
require_relative 'events/guild_create'
require_relative 'events/guild_delete'
require_relative 'events/interaction_create'
require_relative 'events/message_create'
require_relative 'commands/slash/ping'
require_relative 'handlers/anti_crash'
require_relative 'handlers/logger'
require_relative 'database/mongo'

puts "\e[36m\u2554\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2557\e[0m"
puts "\e[36m\u2551     Starting Discord Handler     \u2551\e[0m"
puts "\e[36m\u255a\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u255d\e[0m"
puts

bot = Discordrb::Bot.new(
  token: Config::TOKEN,
  intents: [:all]
)

config = Config

puts "\e[34m[System] Initializing AntiCrash...\e[0m"
AntiCrash.init(webhook_url: config::ERROR_WEBHOOK)

puts "\e[34m[System] Connecting to MongoDB...\e[0m"
mongo_connected = Mongo.connect(config::MONGO_URI)

bot.ready do |event|
  ReadyEvent.execute(bot, config::BOT_NAME)

  begin
    bot.register_application_command(:ping, 'Replies with Pong!')
    puts "\e[32m[Commands] Slash command 'ping' registered\e[0m"
  rescue StandardError => e
    puts "\e[31m[Commands] Failed to register ping: #{e.message}\e[0m"
  end

  Logger.startup_report(
    Logger::StartupData.new(
      name: config::BOT_NAME,
      prefix: 1,
      slash: 1,
      events: 5,
      anticrash: true,
      mongo: mongo_connected
    )
  )
end

bot.server_create do |event|
  GuildCreateEvent.execute(event.server)
end

bot.server_delete do |event|
  GuildDeleteEvent.execute(event.server)
end

bot.application_command(:ping) do |event|
  SlashPing.call(event)
end

bot.message do |event|
  MessageCreateEvent.execute(event, config::PREFIX)
end

bot.run
