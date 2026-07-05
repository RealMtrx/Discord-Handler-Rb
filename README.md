# Discord Handler Ruby

A modern, feature-rich Discord bot handler built with **discordrb**, featuring both slash commands and prefix commands with a robust modular architecture designed for scalability and maintainability.

## 🚀 Features

- **Dual Command System**: Support for both slash commands and prefix commands
- **Modular Architecture**: Clean separation of concerns with dedicated handlers
- **Anti-Crash System**: Comprehensive error handling and monitoring
- **Event-Driven**: Fully event-driven architecture
- **Webhook Logging**: Real-time logging for errors and guild events
- **MongoDB Integration**: Persistent data storage with mongo gem
- **Cooldown System**: Per-command cooldown management
- **Environment Configuration**: Secure configuration with dotenv

## 📁 Project Structure

```
Discord-Handler-Rb/
├── Gemfile                       # Ruby gem dependencies
├── src/                          # Source code
│   ├── main.rb                   # Main bot entry point
│   ├── config/Config.rb          # Bot configuration from .env
│   ├── Core/                     # Core utilities
│   │   ├── CommandUtils.rb       # Cooldown and utilities
│   │   ├── Emojis.rb             # Centralized emoji definitions
│   │   └── WebhookUtil.rb        # Webhook utility
│   ├── Database/
│   │   └── Mongo.rb              # MongoDB connection setup
│   ├── Events/                   # Discord event handlers
│   │   ├── GuildCreate.rb        # Handler when bot joins a server
│   │   ├── GuildDelete.rb        # Handler when bot leaves a server
│   │   ├── InteractionCreate.rb  # Handles slash command interactions
│   │   ├── MessageCreate.rb      # Handles prefix commands
│   │   └── Ready.rb              # Bot ready event
│   ├── Handlers/                 # Handlers for modularity
│   │   ├── AntiCrash.rb          # Crash prevention and error handling
│   │   └── Logger.rb             # Logger for bot activity
│   ├── Models/
│   │   └── UserModel.rb          # User data model
│   └── Commands/
│       ├── Prefix/               # Prefix commands
│       │   └── ping.rb           # Example prefix ping command
│       └── Slash/                # Slash commands
│           └── ping.rb           # Example slash ping command
```

## 🔧 Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/RealMtrx/Discord-Handler-Rb.git
   cd Discord-Handler-Rb
   ```

2. **Install dependencies**

   ```bash
   bundle install
   ```

3. **Environment Setup**

   Copy `.env.example` to `.env` and fill in your values:

   ```env
   TOKEN=your_bot_token_here
   PREFIX=!
   BOT_NAME=Discord Handler
   MONGO_URI=mongodb://localhost:27017/discord-handler
   ERROR_WEBHOOK=https://discord.com/api/webhooks/your_webhook
   GUILD_LOG_WEBHOOK=https://discord.com/api/webhooks/your_webhook
   ```

4. **Run the bot**

   ```bash
   ruby src/main.rb
   ```

## 📋 Dependencies

- **discordrb**: ~> 3.5 - Discord API wrapper
- **mongo**: ~> 2.19 - MongoDB driver
- **dotenv**: ~> 3.1 - Environment variable management
- **net-http**: ~> 0.4 - HTTP client for webhooks

## 📝 Command Development

### Creating Slash Commands

Create a new file in `src/Commands/Slash/[name].rb`:

```ruby
module SlashCommands
  module Ping
    NAME = 'ping'
    DESCRIPTION = 'Replies with Pong!'

    def self.call(event)
      event.respond(content: 'Pong! 🏓')
    end
  end
end
```

### Creating Prefix Commands

Create a new file in `src/Commands/Prefix/[name].rb`:

```ruby
module PrefixCommands
  module Ping
    NAME = 'ping'

    def self.call(event)
      event.respond('Pong! 🏓')
    end
  end
end
```

---

**Discord Handler** — Built by **Mtrx** — Discord: **0hu2**
