class RelayTty < Formula
  desc "Terminal sessions that outlive the terminal, from a browser or Max Pane"
  homepage "https://github.com/ddrscott/relay-tty"
  url "https://registry.npmjs.org/relay-tty/-/relay-tty-1.23.0.tgz"
  sha256 "0ae982cd5a1b69277552c6f5035300210d109b209672b3490fcb7d700cb62f90"
  license "MIT"

  depends_on "node"

  # The npm package's postinstall downloads this binary from the matching
  # GitHub release. Homebrew's install sandbox has no network, so the same
  # asset is declared here as a resource and fetched before the sandbox
  # closes; the postinstall is skipped and never misses it.
  on_macos do
    on_arm do
      resource "pty-host" do
        url "https://github.com/ddrscott/relay-tty/releases/download/v1.23.0/relay-pty-host-aarch64-apple-darwin",
            using: :nounzip
        sha256 "0193a190258c27d69176a4e1c768f68f2efe2d3e1f0876e49e08406a37f06849"
      end
    end
    on_intel do
      resource "pty-host" do
        url "https://github.com/ddrscott/relay-tty/releases/download/v1.23.0/relay-pty-host-x86_64-apple-darwin",
            using: :nounzip
        sha256 "b7c5249e0d36997438b85221e8b2a8e0047179dd5d2ff000b08ed234853543e3"
      end
    end
  end

  on_linux do
    on_arm do
      resource "pty-host" do
        url "https://github.com/ddrscott/relay-tty/releases/download/v1.23.0/relay-pty-host-aarch64-unknown-linux-gnu",
            using: :nounzip
        sha256 "3699804e9b9f81281bd93c17c4fc74153fc2ffd8fb5760924465ebbbff35b3ff"
      end
    end
    on_intel do
      resource "pty-host" do
        url "https://github.com/ddrscott/relay-tty/releases/download/v1.23.0/relay-pty-host-x86_64-unknown-linux-gnu",
            using: :nounzip
        sha256 "0ced451bbcd165dc61f49c1800def8f4566dc24857968c9f1465458aaac76435"
      end
    end
  end

  def install
    # Both relay's own resolver and Max Pane's look for the host at
    # <package>/bin/relay-pty-host, so that is where the resource lands.
    ENV["RELAY_SKIP_BINARY_DOWNLOAD"] = "1"
    system "npm", "install", *std_npm_args, "--ignore-scripts"
    package = libexec/"lib/node_modules/relay-tty"
    resource("pty-host").stage do
      (package/"bin").install Dir["relay-pty-host-*"].first => "relay-pty-host"
    end
    chmod 0755, package/"bin/relay-pty-host"
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # On PATH as well, for anything that asks `which relay-pty-host`.
    bin.install_symlink package/"bin/relay-pty-host"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/relay --version")
    assert_predicate bin/"relay-pty-host", :executable?
  end
end
