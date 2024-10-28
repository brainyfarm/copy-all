class Copyall < Formula
  desc "CopyAll - A customizable file copying script"
  homepage "https://github.com/brainyfarm/homebrew-copyall"
  url "https://github.com/brainyfarm/homebrew-copyall/releases/download/v.0.3.2/copyall-0.3.2.tar.gz"
  sha256 "3af48c042aeb5b19abe151e574e9b4877ec59f8664138f365c439dc6eb685f6e"
  license "MIT"

  def install
    libexec.install Dir["src/*"]

    (bin/"copyall").write <<~EOS
      #!/bin/bash
      # Wrapper script to add libexec to PATH and execute main.sh
      export PATH="#{libexec}:$PATH"
      exec "#{libexec}/main.sh" "$@"
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/copyall --help")
  end
end
