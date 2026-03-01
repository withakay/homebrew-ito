class ItoCli < Formula
  desc "Command-line interface for Ito"
  homepage "https://github.com/withakay/ito"
  version "0.1.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/withakay/ito/releases/download/v0.1.13/ito-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9e3be6cf3915251e34645a0052d2992157489c12639e965f3a8148baef0461c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/withakay/ito/releases/download/v0.1.13/ito-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0ab44a904a4a9ea96af15c8ef1c8c6b9571435b6a85feaeec4bd66b2bc6eb4f5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/withakay/ito/releases/download/v0.1.13/ito-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0136dab4ee37835362f326ef2cc80a8bebb8193e54ba46f7599b02b4811b7f7c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/withakay/ito/releases/download/v0.1.13/ito-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6573b416bebeb3cb1243196572be5f9ab30eb64e5057d74e4d39a388beb74d8e"
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
