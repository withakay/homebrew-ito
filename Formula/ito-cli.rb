class ItoCli < Formula
  desc "Command-line interface for Ito"
  homepage "https://github.com/withakay/ito"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/withakay/ito/releases/download/v0.1.6/ito-cli-aarch64-apple-darwin.tar.xz"
      sha256 "dbe795476f2566bbdc257ff2d636275afe9658462e5ac6ff32fae4f4682f7435"
    end
    if Hardware::CPU.intel?
      url "https://github.com/withakay/ito/releases/download/v0.1.6/ito-cli-x86_64-apple-darwin.tar.xz"
      sha256 "9db5d49982ec32169d8ce551d3812ae97e324d0544c3a0fde2b99791350b140b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/withakay/ito/releases/download/v0.1.6/ito-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ed92e788b8c69e8c59fc0c777f7ba15a8b0ef5db0886d8dae2156bb268218a71"
    end
    if Hardware::CPU.intel?
      url "https://github.com/withakay/ito/releases/download/v0.1.6/ito-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6d01efdfdd1f395b0564e35f177539cb717f5f57c451a2c8fc26eaee01082d37"
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
