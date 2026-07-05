module Logger
  StartupData = Struct.new(:name, :prefix, :slash, :events, :anticrash, :mongo, keyword_init: true)

  def self.startup_report(data)
    puts "\n\e[36m#{'=' * 50}\e[0m"
    puts "\e[36m   #{data.name} — Startup Report\e[0m"
    puts "\e[36m#{'=' * 50}\e[0m"
    puts "  \e[33mPrefix Commands:\e[0m    #{data.prefix}"
    puts "  \e[33mSlash Commands:\e[0m     #{data.slash}"
    puts "  \e[33mEvents Loaded:\e[0m      #{data.events}"
    puts "  \e[33mAntiCrash:\e[0m          #{data.anticrash ? "\e[32mActive\e[0m" : "\e[31mDisabled\e[0m"}"
    puts "  \e[33mMongoDB:\e[0m            #{data.mongo ? "\e[32mConnected\e[0m" : "\e[31mDisconnected\e[0m"}"
    puts "\e[36m#{'=' * 50}\e[0m"
    puts "\e[32m  Bot is fully operational!\e[0m\n\n"
  end
end
