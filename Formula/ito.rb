# typed: false
# frozen_string_literal: true

class Ito < Formula
  desc "Spec-driven workflow management for AI-assisted development"
  homepage "https://github.com/withakay/ito"
  license "MIT"
  version "0.0.0"

  # Placeholder URLs - will be updated by CI on first release
  on_intel do
    on_macos do
      url "https://github.com/withakay/ito/releases/download/v0.0.0/ito-v0.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end

    on_linux do
      url "https://github.com/withakay/ito/releases/download/v0.0.0/ito-v0.0.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  on_arm do
    on_macos do
      url "https://github.com/withakay/ito/releases/download/v0.0.0/ito-v0.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end

    on_linux do
      url "https://github.com/withakay/ito/releases/download/v0.0.0/ito-v0.0.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  head "https://github.com/withakay/ito.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  head do
    depends_on "rust" => :build
  end

  def install
    if build.head?
      cd "ito-rs" do
        system "cargo", "install", *std_cargo_args(path: "crates/ito-cli")
      end
    else
      bin.install "ito"
    end
  end

  test do
    output = shell_output("#{bin}/ito --version").strip
    if build.head?
      assert_match(/^\d+\.\d+\.\d+/, output)
    else
      assert_match(/^#{Regexp.escape(version.to_s)}$/, output)
    end
  end
end
