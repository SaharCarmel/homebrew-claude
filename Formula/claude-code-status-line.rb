class ClaudeCodeStatusLine < Formula
  desc "Enhanced status line for Claude Code with intelligent conversation summaries"
  homepage "https://github.com/SaharCarmel/claude-code-status-line"
  url "https://github.com/SaharCarmel/claude-code-status-line/archive/refs/tags/v1.3.3tar.gz"
  sha256 "488d1f2cfaf3375d57b479474ce1399e77b44aba72c70709130be8df9d6a940c"
  license "MIT"
  version "1.3.3"

  depends_on "jq"
  depends_on "node" # for bun/ccusage

  def install
    # Create .claude directory in user's home
    claude_dir = "#{ENV["HOME"]}/.claude"
    system "mkdir", "-p", claude_dir
    system "mkdir", "-p", "#{claude_dir}/statusline-summaries"
    
    # Install the main script
    system "cp", "statusline-haiku-summary.sh", "#{claude_dir}/statusline-haiku-summary.sh"
    system "chmod", "+x", "#{claude_dir}/statusline-haiku-summary.sh"
    
    # Create a symlink in brew prefix for easy access
    bin.install_symlink "#{claude_dir}/statusline-haiku-summary.sh" => "claude-status-line"
  end

  def caveats
    <<~EOS
      🎉 Claude Code Status Line installed successfully!
      
      📝 Next step: Add this to your ~/.claude/settings.json:
      
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
    assert_predicate "#{ENV["HOME"]}/.claude/statusline-haiku-summary.sh", :exist?
    assert_predicate "#{ENV["HOME"]}/.claude/statusline-haiku-summary.sh", :executable?
  end
end