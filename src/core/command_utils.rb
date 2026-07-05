module CommandUtils
  @cooldowns = {}

  def self.cooldown(user_id, command, seconds = 3)
    key = "#{user_id}:#{command}"
    now = Time.now.to_f
    last = @cooldowns[key]
    if last && (now - last) < seconds
      remaining = (seconds - (now - last)).round(1)
      return remaining
    end
    @cooldowns[key] = now
    nil
  end
end
