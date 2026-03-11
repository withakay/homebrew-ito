class Ito < Formula
  desc "Command-line interface for Ito"
  homepage "https://github.com/withakay/ito"
  version "0.1.20"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/withakay/ito/releases/download/v0.1.20/ito-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5dd33cc0f7702fcf678d332edf74b52de966762e267726996b74084b5fda4509"
    end
    if Hardware::CPU.intel?
      url "https://github.com/withakay/ito/releases/download/v0.1.20/ito-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b919dc14af87a5bcfb121814163c6db9ae8c12f3fe3a875291139fdd92443404"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/withakay/ito/releases/download/v0.1.20/ito-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e8c6bb3dd8f98fe5da7c3db1e7115046f77fc3c49e9bc28a6d16972b82561dba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/withakay/ito/releases/download/v0.1.20/ito-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3a7c1b296f63405122c5035809eac7a5560e3afd844661ea007764915eb25d00"
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
    run [opt_bin/"ito", "serve-api", "--service"]
    keep_alive true
    log_path var/"log/ito-backend.log"
    error_log_path var/"log/ito-backend.log"
  end
end
