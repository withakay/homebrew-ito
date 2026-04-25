class Ito < Formula
  desc "Command-line interface for Ito"
  homepage "https://github.com/withakay/ito"
  version "0.1.28"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/withakay/ito/releases/download/v0.1.28/ito-cli-aarch64-apple-darwin.tar.xz"
      sha256 "805f57a4d86737d25b192e24ee1e81ea17b5fb3ca371b90f04d8f4106173073d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/withakay/ito/releases/download/v0.1.28/ito-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8d353ab23847fbb791cdc7619e59cf1d6b55c6259e3adbf846204021b73ead41"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/withakay/ito/releases/download/v0.1.28/ito-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "41a231d8dab2b68854bae36b347e0d62f6fb8613164888ab74e3e801e9d056ed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/withakay/ito/releases/download/v0.1.28/ito-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f787ed73c1b8a09057e90b2a5859cc9cfe9ee887d5ddfe95572c586af2f773ad"
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

  service do
    run [opt_bin/"ito", "backend", "serve", "--service"]
    keep_alive true
    log_path var/"log/ito-backend.log"
    error_log_path var/"log/ito-backend.log"
  end
end
