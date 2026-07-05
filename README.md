<div align="center">
  <h1>Discord Handler — Ruby</h1>
  <p><strong>A production-ready Discord bot framework built with discordrb and MongoDB — slash commands, prefix commands, anti-crash, webhook logging, and a modular src/ architecture.</strong></p>

  <p>
    <a href="https://github.com/RealMtrx/Discord-Handler-Rb/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"></a>
    <a href="https://github.com/RealMtrx/Discord-Handler-Rb/releases"><img src="https://img.shields.io/badge/version-0.9.0--beta-yellow" alt="Version 0.9.0 Beta"></a>
    <a href="https://github.com/RealMtrx/Discord-Handler-Rb/stargazers"><img src="https://img.shields.io/github/stars/RealMtrx/Discord-Handler-Rb" alt="Stars"></a>
    <a href="https://github.com/RealMtrx/Discord-Handler-Rb/issues"><img src="https://img.shields.io/github/issues/RealMtrx/Discord-Handler-Rb" alt="Issues"></a>
    <a href="https://github.com/RealMtrx/Discord-Handler-Rb/network"><img src="https://img.shields.io/github/forks/RealMtrx/Discord-Handler-Rb" alt="Forks"></a>
    <a href="https://github.com/RealMtrx/Discord-Handler/graphs/contributors"><img src="https://img.shields.io/badge/ecosystem-26%20repos-brightgreen" alt="26 Repos"></a>
    <a href="https://discord.gg/0hu2"><img src="https://img.shields.io/badge/discord-0hu2-5865F2" alt="Discord"></a>
  </p>

  <br>

  <p>
    <a href="#-features">Features</a> •
    <a href="#-quick-start">Quick Start</a> •
    <a href="#-project-structure">Structure</a> •
    <a href="#-api-reference">API</a> •
    <a href="#-database-edition">SQL Edition</a> •
    <a href="#-related-repositories">Ecosystem</a>
  </p>
</div>

---

## Overview

Discord Handler Ruby is the **Ruby edition** of the multi-language Discord Handler ecosystem. Built on the `discordrb` gem (~> 3.5), it provides a modular, event-driven foundation for Discord bots with dual command support (slash + prefix), MongoDB persistence, webhook-based logging, and an anti-crash layer.

The entry point (`src/main.rb`) boots in a predictable sequence: initialize the anti-crash handler, connect to MongoDB, register global slash commands, attach all five event listeners (ready, guild create/delete, interaction create, message create), and finally present a startup report before going online.

## Features

- **Dual Command System** — Slash commands via `register_application_command` and prefix commands via `bot.message`
- **Modular Architecture** — Separated concerns across `config/`, `core/`, `database/`, `events/`, `handlers/`, `models/`, and `commands/`
- **Anti-Crash** — Global error interception that reports failures to a Discord webhook
- **Webhook Logging** — Separate webhooks for error alerts and guild join/leave events
- **MongoDB Integration** — Persistent storage via the `mongo` gem (~> 2.19)
- **Cooldown System** — Per-command cooldown tracked in `core/command_utils.rb`
- **Environment Configuration** — All secrets managed through `.env` with `dotenv` (~> 3.1)

## Quick Start

```bash
git clone https://github.com/RealMtrx/Discord-Handler-Rb.git
cd Discord-Handler-Rb
bundle install
```

Copy `.env.example` to `.env` and fill in your values:

```env
TOKEN=your_bot_token_here
PREFIX=!
BOT_NAME=Discord Handler
MONGO_URI=mongodb://localhost:27017/discord-handler
ERROR_WEBHOOK=https://discord.com/api/webhooks/your_webhook
GUILD_LOG_WEBHOOK=https://discord.com/api/webhooks/your_webhook
```

```bash
ruby src/main.rb
```

### Dependencies

| Gem | Version | Purpose |
|-----|---------|---------|
| `discordrb` | ~> 3.5 | Discord API wrapper |
| `mongo` | ~> 2.19 | MongoDB driver |
| `dotenv` | ~> 3.1 | Environment variable management |
| `net-http` | ~> 0.4 | HTTP client for webhooks |

## Project Structure

```
Discord-Handler-Rb/
├── Gemfile
├── .env.example
├── src/
│   ├── main.rb                      # Entry point — boot sequence
│   ├── config/config.rb             # Loads and exposes .env values
│   ├── core/
│   │   ├── command_utils.rb         # Cooldown helper
│   │   ├── emojis.rb                # Centralized emoji constants
│   │   └── webhook_util.rb          # Webhook dispatch utility
│   ├── database/mongo.rb            # MongoDB connection wrapper
│   ├── events/
│   │   ├── guild_create.rb          # Guild join → webhook
│   │   ├── guild_delete.rb          # Guild leave → webhook
│   │   ├── interaction_create.rb    # Slash command dispatcher
│   │   ├── message_create.rb        # Prefix command dispatcher
│   │   └── ready.rb                 # Ready event + startup report
│   ├── handlers/
│   │   ├── anti_crash.rb            # Global error interception
│   │   └── logger.rb                # Startup report formatter
│   ├── models/user_model.rb         # User data schema
│   └── commands/
│       ├── prefix/ping.rb           # Example prefix command
│       └── slash/ping.rb            # Example slash command
```

## API Reference

### Entry Point — `src/main.rb`

Creates a `Discordrb::Bot` with all intents, wires five event handlers, registers slash commands on ready, and calls `bot.run`.

### Configuration — `src/config/config.rb`

```ruby
Config::TOKEN       # Bot token
Config::PREFIX      # Command prefix (default: "!")
Config::BOT_NAME    # Display name
Config::MONGO_URI   # MongoDB connection string
Config::ERROR_WEBHOOK      # Error reporting URL
Config::GUILD_LOG_WEBHOOK  # Guild event logging URL
```

### Events

| Event | File | Trigger |
|-------|------|---------|
| `ready` | `events/ready.rb` | Bot goes online — registers slash commands, logs startup |
| `guild_create` | `events/guild_create.rb` | Bot joins a server — sends join webhook |
| `guild_delete` | `events/guild_delete.rb` | Bot leaves a server — sends leave webhook |
| `interaction_create` | `events/interaction_create.rb` | Slash command used — routes to command module |
| `message_create` | `events/message_create.rb` | Message sent — checks prefix, routes to prefix command |

### Core Utilities

- **CommandUtils** — `CommandUtils.cooldown?(command, user_id)` checks cooldown expiry
- **WebhookUtil** — `WebhookUtil.send(webhook_url, content)` fires an embed to a Discord webhook
- **Emojis** — Centralized emoji constant map for consistent bot responses

## Adding Commands

### Slash Command

Create `src/commands/slash/your_command.rb`:

```ruby
module SlashCommands
  module YourCommand
    NAME = 'yourcommand'
    DESCRIPTION = 'Does something useful'

    def self.call(event)
      event.respond(content: 'Done!')
    end
  end
end
```

Then register it in `src/main.rb` inside the `ready` block:

```ruby
bot.register_application_command(:yourcommand, 'Does something useful')
```

### Prefix Command

Create `src/commands/prefix/your_command.rb`:

```ruby
module PrefixCommands
  module YourCommand
    NAME = 'yourcommand'

    def self.call(event)
      event.respond('Done!')
    end
  end
end
```

The `message_create` event automatically dispatches to modules in `commands/prefix/` when the message starts with `PREFIX`.

## Database Edition

A **Sequelize (SQL)** variant of this handler is available for teams that prefer a relational database over MongoDB:

[RealMtrx/Discord-Handler-Rb-Sequelize](https://github.com/RealMtrx/Discord-Handler-Rb-Sequelize)

It replaces `database/mongo.rb` with a Sequelize-based connection and supports SQLite, PostgreSQL, MySQL, MariaDB, and MSSQL out of the box. All other modules — events, commands, handlers, core utilities — remain identical.

## Related Repositories

The Discord Handler ecosystem spans **26 repositories** across 13 languages, each available in both MongoDB and Sequelize editions.

### Base Repositories (MongoDB)

| Language | Repository |
|----------|------------|
| C++ | [RealMtrx/Discord-Handler-Cpp](https://github.com/RealMtrx/Discord-Handler-Cpp) |
| C# | [RealMtrx/Discord-Handler-Cs](https://github.com/RealMtrx/Discord-Handler-Cs) |
| Dart | [RealMtrx/Discord-Handler-Dart](https://github.com/RealMtrx/Discord-Handler-Dart) |
| Go | [RealMtrx/Discord-Handler-Go](https://github.com/RealMtrx/Discord-Handler-Go) |
| Java | [RealMtrx/Discord-Handler-Java](https://github.com/RealMtrx/Discord-Handler-Java) |
| JavaScript | [RealMtrx/Discord-Handler-Js](https://github.com/RealMtrx/Discord-Handler-Js) |
| Kotlin | [RealMtrx/Discord-Handler-Kt](https://github.com/RealMtrx/Discord-Handler-Kt) |
| Lua | [RealMtrx/Discord-Handler-Lua](https://github.com/RealMtrx/Discord-Handler-Lua) |
| PHP | [RealMtrx/Discord-Handler-Php](https://github.com/RealMtrx/Discord-Handler-Php) |
| Python | [RealMtrx/Discord-Handler-Py](https://github.com/RealMtrx/Discord-Handler-Py) |
| Ruby | [RealMtrx/Discord-Handler-Rb](https://github.com/RealMtrx/Discord-Handler-Rb) |
| Rust | [RealMtrx/Discord-Handler-Rs](https://github.com/RealMtrx/Discord-Handler-Rs) |
| TypeScript | [RealMtrx/Discord-Handler](https://github.com/RealMtrx/Discord-Handler) ← hub |

### Sequelize (SQL) Editions

| Language | Repository |
|----------|------------|
| C++ | [RealMtrx/Discord-Handler-Cpp-Sequelize](https://github.com/RealMtrx/Discord-Handler-Cpp-Sequelize) |
| C# | [RealMtrx/Discord-Handler-Cs-Sequelize](https://github.com/RealMtrx/Discord-Handler-Cs-Sequelize) |
| Dart | [RealMtrx/Discord-Handler-Dart-Sequelize](https://github.com/RealMtrx/Discord-Handler-Dart-Sequelize) |
| Go | [RealMtrx/Discord-Handler-Go-Sequelize](https://github.com/RealMtrx/Discord-Handler-Go-Sequelize) |
| Java | [RealMtrx/Discord-Handler-Java-Sequelize](https://github.com/RealMtrx/Discord-Handler-Java-Sequelize) |
| JavaScript | [RealMtrx/Discord-Handler-Js-Sequelize](https://github.com/RealMtrx/Discord-Handler-Js-Sequelize) |
| Kotlin | [RealMtrx/Discord-Handler-Kt-Sequelize](https://github.com/RealMtrx/Discord-Handler-Kt-Sequelize) |
| Lua | [RealMtrx/Discord-Handler-Lua-Sequelize](https://github.com/RealMtrx/Discord-Handler-Lua-Sequelize) |
| PHP | [RealMtrx/Discord-Handler-Php-Sequelize](https://github.com/RealMtrx/Discord-Handler-Php-Sequelize) |
| Python | [RealMtrx/Discord-Handler-Py-Sequelize](https://github.com/RealMtrx/Discord-Handler-Py-Sequelize) |
| Ruby | [RealMtrx/Discord-Handler-Rb-Sequelize](https://github.com/RealMtrx/Discord-Handler-Rb-Sequelize) |
| Rust | [RealMtrx/Discord-Handler-Rs-Sequelize](https://github.com/RealMtrx/Discord-Handler-Rs-Sequelize) |
| TypeScript | [RealMtrx/Discord-Handler-Ts-Sequelize](https://github.com/RealMtrx/Discord-Handler-Ts-Sequelize) |

> **[RealMtrx/Discord-Handler](https://github.com/RealMtrx/Discord-Handler)** — the TypeScript hub and flagship repository. Star it to support the ecosystem.

## License

Distributed under the MIT License. See `LICENSE` for more information.

---

Built by **Mtrx** — Discord: **0hu2**
