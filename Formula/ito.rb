class Ito < Formula
  desc "Command-line interface for Ito"
  homepage "https://github.com/withakay/ito"
  version "0.1.25"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/withakay/ito/releases/download/v0.1.25/ito-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5779c7ebcad5e35cb14dbfbd354de239118207514f951941cef9f046d4ec50dc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/withakay/ito/releases/download/v0.1.25/ito-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a51a1ecff90d90f8d514e7d89a744ff965231424ae7316286f12cdb4818a7f23"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/withakay/ito/releases/download/v0.1.25/ito-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "047c9fc2a5ad95ce36e19fa7975a2a93340d8ea924f758cbe9a7203cf3c9326a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/withakay/ito/releases/download/v0.1.25/ito-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2041e1e86a6244ec85e4d14ac641db6bca1c69812672fe912c58a9729bb7ac7c"
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
