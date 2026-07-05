require_relative '../commands/prefix/ping'
require_relative '../core/emojis'

module MessageCreateEvent
  def self.execute(event, prefix)
    return if event.author.bot_account?

    content = event.content
    return unless content.start_with?(prefix)

    args = content[prefix.length..].split
    cmd_name = args.first&.downcase
    args = args[1..] || []

    case cmd_name
    when PrefixPing::NAME
      PrefixPing.call(event)
    else
      event.respond("#{Emojis::ERROR} Unknown command. Use `#{prefix}help` for a list of commands.")
    end
  rescue StandardError => e
    puts "\e[31m[MessageCreate] Error in prefix command: #{e.message}\e[0m"
  end
end
