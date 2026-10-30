class SbtServer < Formula
  desc "Warm sbt per project for agent-driven builds: the sbtd daemon and the sbtctl CLI"
  homepage "https://github.com/scottweaver/sbt-server"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/scottweaver/sbt-server/releases/download/v0.1.1/sbt-server-aarch64-apple-darwin.tar.xz"
      sha256 "3cf1dca9524106ce0970a5fcc3155a757be92749485331716f1be913fa65641a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scottweaver/sbt-server/releases/download/v0.1.1/sbt-server-x86_64-apple-darwin.tar.xz"
      sha256 "990ee0e646c58ee1567e3214a090948ae37e21baf7eeeef02d52d60f494e3738"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/scottweaver/sbt-server/releases/download/v0.1.1/sbt-server-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "cef95475101ec2a364a1ac107330119796adeac59a2433dd60c4212177baaad8"
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "sbtctl", "sbtd"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "sbtctl", "sbtd"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "sbtctl", "sbtd"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
