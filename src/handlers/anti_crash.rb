require_relative '../core/webhook_util'

module AntiCrash
  @webhook_url = nil

  def self.init(webhook_url: nil)
    @webhook_url = webhook_url

    Thread.new do
      loop do
        begin
          Thread.stop
        rescue StandardError => e
          report_error('Unhandled Thread Error', "#{e.message}\n#{e.backtrace&.first(5)&.join("\n")}")
        end
      end
    end

    puts "\e[32m[AntiCrash] Active\e[0m"
  end

  def self.report_error(title, message)
    puts "\e[31m[AntiCrash] #{title}: #{message}\e[0m"
    if @webhook_url
      WebhookUtil.send_webhook(@webhook_url, "**#{title}**\n```\n#{message}\n```")
    end
  end
end

at_exit do
  puts "\e[31m[AntiCrash] Process terminating...\e[0m"
end
