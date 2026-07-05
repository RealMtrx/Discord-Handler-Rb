require_relative '../../core/emojis'

module SlashPing
  NAME = 'ping'
  DESCRIPTION = 'Replies with Pong!'

  def self.call(event)
    latency = ((Time.now.to_f - event.id.to_i / 1000.0) * 1000).round
    event.respond(
      content: "#{Emojis::PING} **Pong!** \uD83C\uDFD3\n\u23F1\uFE0F Latency: `#{latency}ms`"
    )
  end
end
