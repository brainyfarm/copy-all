class Copyall < Formula
    desc "CopyAll - A customizable file copying script"
    homepage "https://github.com/brainyfarm/homebrew-copyall"
    url "https://github.com/brainyfarm/homebrew-copyall/archive/refs/tags/v0.3.0.tar.gz"
    sha256 "UPDATED_SHA256_CHECKSUM"
    license "MIT"
  
    depends_on "bash"
  
    def install
      bin.install "src/main.sh" => "copyall"
      prefix.install "src"
    end
  
    test do
      assert_match "Usage:", shell_output("#{bin}/copyall --help")
    end
  end
  