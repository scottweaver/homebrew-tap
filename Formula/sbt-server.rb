class SbtServer < Formula
  desc "Warm sbt per project for agent-driven builds: the sbtd daemon and the sbtctl CLI"
  homepage "https://github.com/scottweaver/sbt-server"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/scottweaver/sbt-server/releases/download/v0.1.2/sbt-server-aarch64-apple-darwin.tar.xz"
      sha256 "e39a3206c16647fa62ce3fa787caf390a254f750c150feaebc6086622a2f47f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scottweaver/sbt-server/releases/download/v0.1.2/sbt-server-x86_64-apple-darwin.tar.xz"
      sha256 "3f28e2ab0a7e5ab6fb3e3500bf5383007dff56fdde28ccfd23c4cd10f8b1e303"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/scottweaver/sbt-server/releases/download/v0.1.2/sbt-server-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "e9fee74db3f7ba2ace9c9bd375722463ece51c46f0f6e6bef836516fd0215f87"
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
