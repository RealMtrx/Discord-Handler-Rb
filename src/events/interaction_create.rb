require_relative '../commands/slash/ping'
require_relative '../core/emojis'

module InteractionCreateEvent
  def self.execute(event)
    return unless event.is_a?(Discordrb::Commands::ApplicationCommandEvent)

    cmd = event.command_name

    begin
      case cmd
      when SlashPing::NAME
        SlashPing.call(event)
      else
        event.respond(
          content: "#{Emojis::ERROR} Unknown command.",
          ephemeral: true
        )
      end
    rescue StandardError => e
      puts "\e[31m[InteractionCreate] Error in /#{cmd}: #{e.message}\e[0m"
      unless event.responded?
        event.respond(
          content: "#{Emojis::ERROR} Error executing command!",
          ephemeral: true
        )
      end
    end
  end
end
