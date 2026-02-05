# typed: false
# frozen_string_literal: true

class Ito < Formula
  desc "Spec-driven workflow management for AI-assisted development"
  homepage "https://github.com/withakay/ito"
  license "MIT"
  version "0.1.0"

  on_intel do
    on_macos do
      url "https://github.com/withakay/ito/releases/download/v0.1.0/ito-v0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "31166f53388d9086e82110bfaa7fefb3608e17c56cd01c36b98fc7d66ea46b4e"
    end

    on_linux do
      url "https://github.com/withakay/ito/releases/download/v0.1.0/ito-v0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6d448539ffe58ea321fcdf0a8d1796cce55c5f78b0f4eca316c68c56985ddfdf"
    end
  end

  on_arm do
    on_macos do
      url "https://github.com/withakay/ito/releases/download/v0.1.0/ito-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "0058a6145aa042a6222edbdf33634719268ad78e479e59f12a18f230b138fe4d"
    end

    on_linux do
      url "https://github.com/withakay/ito/releases/download/v0.1.0/ito-v0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "222b0690acc4484001d79f68ea271f2ada6c691cc1cc06441b21501d40e08f90"
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
