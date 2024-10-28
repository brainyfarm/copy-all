class Copyall < Formula
  desc "CopyAll - A customizable file copying script"
  homepage "https://github.com/brainyfarm/homebrew-copyall"
  url "https://github.com/brainyfarm/homebrew-copyall/releases/download/v0.3.0/copyall-0.3.0.tar.gz"
  sha256 "01d270a2c78df5b63b149e9dfb726ce0a4f660d8abec9f12a6f93a149111f8dd"
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
