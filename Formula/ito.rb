class Ito < Formula
  desc "Command-line interface for Ito"
  homepage "https://github.com/withakay/ito"
  version "0.1.29"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/withakay/ito/releases/download/v0.1.29/ito-cli-aarch64-apple-darwin.tar.xz"
      sha256 "118f4d8625d206c8bcefdf22926028c7d586e4fa9d1289aa348fe9fb8915d3fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/withakay/ito/releases/download/v0.1.29/ito-cli-x86_64-apple-darwin.tar.xz"
      sha256 "36455c9b3017b5649ea96bcb2b13db597840e883cc2e7257667463bd4980c77e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/withakay/ito/releases/download/v0.1.29/ito-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b0f73f2fef1ad1fe0772996f3c651ca2aae6f41abc8e1447a12a997bb820bff1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/withakay/ito/releases/download/v0.1.29/ito-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "52b06eccf31b2b28920acc73a32724603921ca396f83c9accfeabf6a72739017"
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
