require 'mongo'

module Mongo
  @client = nil
  @connected = false

  def self.connect(uri)
    begin
      @client = Mongo::Client.new(uri)
      @client.database.command(ping: 1)
      @connected = true
      puts "\e[32m[System] MongoDB connected\e[0m"
      true
    rescue StandardError => e
      puts "\e[31m[MongoDB] Connection failed: #{e.message}\e[0m"
      false
    end
  end

  def self.connected?
    @connected
  end

  def self.client
    @client
  end

  def self.disconnect
    @client&.close
    @connected = false
  end
end
