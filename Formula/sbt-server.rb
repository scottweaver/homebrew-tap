class SbtServer < Formula
  desc "Warm sbt per project for agent-driven builds: the sbtd daemon and the sbtctl CLI"
  homepage "https://github.com/scottweaver/sbt-server"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/scottweaver/sbt-server/releases/download/v0.1.0/sbt-server-aarch64-apple-darwin.tar.xz"
      sha256 "e20c91e32abf5b0221b3005607a08f6c0dcf28bc9bfed93e4e0852b0280ead89"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scottweaver/sbt-server/releases/download/v0.1.0/sbt-server-x86_64-apple-darwin.tar.xz"
      sha256 "8a9060984be15fd4dffb4a87e9bd6953b0c803dd6cc98172fce7d673888f38ca"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/scottweaver/sbt-server/releases/download/v0.1.0/sbt-server-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f86947e4999972be75ac15b42cd44c32b3c262bd17df12d8041da617d8bff06d"
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
