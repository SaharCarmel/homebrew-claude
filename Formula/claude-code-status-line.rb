class ClaudeCodeStatusLine < Formula
  desc "Enhanced status line for Claude Code with intelligent conversation summaries"
  homepage "https://github.com/SaharCarmel/claude-code-status-line"
  url "https://github.com/SaharCarmel/claude-code-status-line/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "488d1f2cfaf3375d57b479474ce1399e77b44aba72c70709130be8df9d6a940c"
  license "MIT"
  version "1.3.3"

  depends_on "jq"
  depends_on "node" # for bun/ccusage

  def install
    # Install to libexec and create wrapper script
    libexec.install "statusline-haiku-summary.sh"
    
    # Create wrapper script that installs to ~/.claude on first run
    (bin/"claude-code-status-line-install").write <<~EOS
      #!/bin/bash
      set -e
      
      # Create .claude directory
      mkdir -p "$HOME/.claude"
      mkdir -p "$HOME/.claude/statusline-summaries"
      
      # Copy script to user's home
      cp "#{libexec}/statusline-haiku-summary.sh" "$HOME/.claude/statusline-haiku-summary.sh"
      chmod +x "$HOME/.claude/statusline-haiku-summary.sh"
      
      echo "✅ Claude Code Status Line installed to ~/.claude/"
      echo "📝 Add this to your ~/.claude/settings.json:"
      echo '  "statusLine": {'
      echo '    "type": "command",'
      echo '    "command": "bash ~/.claude/statusline-haiku-summary.sh"'
      echo '  }'
    EOS
  end

  def caveats
    <<~EOS
      🎉 Claude Code Status Line installed successfully!
      
      📥 IMPORTANT: Run this command to complete installation:
        claude-code-status-line-install
      
      📝 Then add this to your ~/.claude/settings.json:
        "statusLine": {
          "type": "command", 
          "command": "bash ~/.claude/statusline-haiku-summary.sh"
        }
      
      🔄 Then restart Claude Code to see intelligent 5-word summaries!
      
      📖 Learn more: https://github.com/SaharCarmel/claude-code-status-line
      📜 Changelog: https://github.com/SaharCarmel/claude-code-status-line/blob/main/CHANGELOG.md
      
      💡 To update: brew upgrade claude-code-status-line
    EOS
  end

  def post_install
    ohai "🔄 Updated to version #{version}!"
    ohai "📥 Don't forget to run: claude-code-status-line-install"
    
    # Fetch and display the latest changelog entry
    changelog_url = "https://raw.githubusercontent.com/SaharCarmel/claude-code-status-line/main/CHANGELOG.md"
    changelog_content = `curl -s "#{changelog_url}"`
    
    if $?.success? && !changelog_content.empty?
      # Extract the latest version section (from [version] to next [version] or end)
      lines = changelog_content.split("\n")
      in_current_version = false
      changelog_lines = []
      
      lines.each do |line|
        if line.match?(/^## \[#{Regexp.escape(version)}\]/)
          in_current_version = true
          changelog_lines << line
        elsif line.match?(/^## \[/) && in_current_version
          break
        elsif in_current_version
          changelog_lines << line
        end
      end
      
      unless changelog_lines.empty?
        ohai "📋 What's New:"
        changelog_lines[0..15].each do |line|  # Show first 15 lines max
          puts "#{line}"
        end
        puts "" if changelog_lines.length > 15
        ohai "📜 Full changelog: https://github.com/SaharCarmel/claude-code-status-line/blob/main/CHANGELOG.md"
      end
    else
      ohai "📜 View what's new: https://github.com/SaharCarmel/claude-code-status-line/blob/main/CHANGELOG.md"
    end
  end

  test do
    assert_predicate libexec/"statusline-haiku-summary.sh", :exist?
    assert_predicate bin/"claude-code-status-line-install", :exist?
    assert_predicate bin/"claude-code-status-line-install", :executable?
    
    # Test that the installer works
    system bin/"claude-code-status-line-install"
    assert_predicate "#{ENV["HOME"]}/.claude/statusline-haiku-summary.sh", :exist?
    assert_predicate "#{ENV["HOME"]}/.claude/statusline-haiku-summary.sh", :executable?
  end
end