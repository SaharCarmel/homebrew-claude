# Homebrew Tap for Claude Code Tools

This tap provides Homebrew formulas for Claude Code utilities and enhancements.

## Installation

First, add the tap:
```bash
brew tap saharcarmel/claude
```

Then install the tools you want:
```bash
brew install claude-code-status-line
```

## Available Formulas

### 🎯 claude-code-status-line

Enhanced status line for Claude Code that shows intelligent 5-word summaries based on your actual conversation history.

**Features:**
- 🏠 Project name and git status
- 🤖 Current AI model  
- 💰 Session costs and performance
- 📝 Code changes tracking
- 🧠 Context window usage
- 🚨 Code quality detection (monitors if Claude is using mocks or taking shortcuts)
- 📋 Smart 5-word summary of what Claude is actually working on

**Installation:**
```bash
brew tap saharcarmel/claude
brew install claude-code-status-line
```

**Configuration:**
After installation, add this to your `~/.claude/settings.json`:
```json
{
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/statusline-haiku-summary.sh"
  }
}
```

**Updates:**
```bash
brew upgrade claude-code-status-line
```

## Repository

- [claude-code-status-line](https://github.com/SaharCarmel/claude-code-status-line) - Enhanced status line with conversation summaries

## Contributing

Feel free to open issues or submit pull requests to improve the formulas!