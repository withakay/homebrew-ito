class ItoCli < Formula
  desc "Command-line interface for Ito"
  homepage "https://github.com/withakay/ito"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/withakay/ito/releases/download/v0.1.7/ito-cli-aarch64-apple-darwin.tar.xz"
      sha256 "37cb5612a2c80a41a03bc28c01b80a6f8b10d1ac3b3618c72e4559fae56d6a3b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/withakay/ito/releases/download/v0.1.7/ito-cli-x86_64-apple-darwin.tar.xz"
      sha256 "70052c4c7881b6148484009bda2ff5b327d7705827cff0ef8d5813116050f12f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/withakay/ito/releases/download/v0.1.7/ito-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7528e6b8bc37066212574382764eb9f39422e75c8b2d203ef59e8f3d7195570e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/withakay/ito/releases/download/v0.1.7/ito-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "92fa95a68f28c0856140ac615909e5bf4349eab22f13a8b926bdfb2b4fe53d4b"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "ito" if OS.mac? && Hardware::CPU.arm?
    bin.install "ito" if OS.mac? && Hardware::CPU.intel?
    bin.install "ito" if OS.linux? && Hardware::CPU.arm?
    bin.install "ito" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
