class ItoCli < Formula
  desc "Command-line interface for Ito"
  homepage "https://github.com/withakay/ito"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/withakay/ito/releases/download/v0.1.5/ito-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5d1a7d24aed6b9730662525d6fbee20aefa7c37708573b7226ff27b247c98e46"
    end
    if Hardware::CPU.intel?
      url "https://github.com/withakay/ito/releases/download/v0.1.5/ito-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f7aca10f50e492d7ed7f283972110139a3a6a73d7c611f49b59ba6c3a8f918df"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/withakay/ito/releases/download/v0.1.5/ito-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c950412294f8e80262104ee1e509dd045f6615affa45f5b3e4fc1fbea56d51f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/withakay/ito/releases/download/v0.1.5/ito-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5001b57b24cf623c8c56809c27d6089d38467a4e9f9ca76404791397095840c1"
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
