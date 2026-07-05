require_relative '../../core/emojis'
require_relative '../../core/command_utils'

module PrefixPing
  NAME = 'ping'

  def self.call(event)
    remaining = CommandUtils.cooldown(event.user.id, 'ping')
    if remaining
      event.respond("#{Emojis::WARNING} Please wait `#{remaining}s` before using this command again.")
      return
    end

    latency = ((Time.now.to_f - event.timestamp.to_time.to_f) * 1000).round
    event.respond("#{Emojis::PING} **Pong!** \uD83C\uDFD3\n\u23F1\uFE0F Latency: `#{latency}ms`")
  end
end
