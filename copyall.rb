class Copyall < Formula
  desc "CopyAll - A customizable file copying script"
  homepage "https://github.com/brainyfarm/homebrew-copyall"
  url "https://github.com/brainyfarm/homebrew-copyall/releases/download/v0.3.1/copyall-0.3.1.tar.gz"
  sha256 "5de910b7f15db14617bf7053ac4a044f836b121a882856c30ece7e32bd4a6de0"
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
