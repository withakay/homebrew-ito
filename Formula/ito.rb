# typed: false
# frozen_string_literal: true

class Ito < Formula
  desc "Spec-driven workflow management for AI-assisted development"
  homepage "https://github.com/withakay/ito"
  license "MIT"
  version "0.1.1"

  on_macos do
    on_intel do
      url "https://github.com/withakay/ito/releases/download/v0.1.1/ito-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b44b4938641aa110394511a5ea7fc19f21ed9562fabc1ad786fcbbe7e0fc5ac2"
    end

    on_arm do
      url "https://github.com/withakay/ito/releases/download/v0.1.1/ito-cli-aarch64-apple-darwin.tar.xz"
      sha256 "39417bcda4ebe4be9a604ce7beab34436bb0103bad30ff4bc3d3201401dcfbcf"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/withakay/ito/releases/download/v0.1.1/ito-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2c0775d2953e8f60e3406cbf4793f1b90054f3121793d1654104b6384bf1185f"
    end

    on_arm do
      url "https://github.com/withakay/ito/releases/download/v0.1.1/ito-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5af524b3ba42f0d12b6df64a31ba28d4e6c9ffea6faf5141890ac8bebe39d562"
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
      system "cargo", "install", *std_cargo_args(path: "ito-rs/crates/ito-cli")
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
