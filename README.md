# Discord Handler Ruby

A modern, feature-rich Discord bot handler built with Ruby and discordrb, featuring both slash commands and prefix commands with a robust modular architecture.

## Features

- Slash commands and prefix commands
- MongoDB integration with mongo gem
- Modular architecture (commands, events, handlers)
- Anti-crash system with error reporting
- Cooldown system
- Unicode emoji exports
- Webhook logging

## Prerequisites

- Ruby 3.0+

## Setup

1. Clone the repository
2. Copy `.env.example` to `.env` and fill in your bot token and other configuration
3. Install dependencies:
```bash
bundle install
```
4. Run the bot:
```bash
ruby src/main.rb
```

## Project Structure

```
src/
├── main.rb                    # Entry point
├── config/config.rb           # Configuration loader
├── commands/slash/ping.rb     # Slash ping command
├── commands/prefix/ping.rb    # Prefix ping command
├── core/emojis.rb             # Unicode emoji exports
├── core/command_utils.rb      # Cooldown utilities
├── core/webhook_util.rb       # Webhook utility
├── database/mongo.rb          # MongoDB connection
├── events/ready.rb            # Ready event
├── events/guild_create.rb     # Guild join event
├── events/guild_delete.rb     # Guild leave event
├── events/interaction_create.rb # Slash command handler
├── events/message_create.rb   # Prefix command handler
├── handlers/anti_crash.rb     # Error handling
├── handlers/logger.rb         # Startup logger
└── models/user_model.rb       # User data model
```

## License

MIT License - see [LICENSE](LICENSE) for details.
