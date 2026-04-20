class Ito < Formula
  desc "Command-line interface for Ito"
  homepage "https://github.com/withakay/ito"
  version "0.1.26"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/withakay/ito/releases/download/v0.1.26/ito-cli-aarch64-apple-darwin.tar.xz"
      sha256 "16af2fe4dbea2e771bbc0dd91be55cedc47a84e30c49ca6941a281ba49da7d64"
    end
    if Hardware::CPU.intel?
      url "https://github.com/withakay/ito/releases/download/v0.1.26/ito-cli-x86_64-apple-darwin.tar.xz"
      sha256 "9c28564c7bb8d8c3efe77dd7ac109d1cb6d410f97c512f5c3decde6d06a4bf18"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/withakay/ito/releases/download/v0.1.26/ito-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6defbb6fdbe0825148f6b1d8517773316d3d815aa7fca41d2d318fe4672dec6a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/withakay/ito/releases/download/v0.1.26/ito-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d2ae7f840cf2ec22304d9975a0d2bf9e3f745cd87d6f5fbc7f805605a9464d53"
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
