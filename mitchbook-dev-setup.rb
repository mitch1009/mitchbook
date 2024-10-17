# mitchbook-dev-setup.rb

class MitchbookDevSetup < Formula
    desc "Configure MacBook for development with git, GitHub, npm, Java,docker and useful aliases"
    homepage "https://github.com/mitch1009/mitchbook"
    url "https://github.com/mitch1009/mitchbook/archive/refs/heads/main.zip"
    sha256 "replace_with_actual_sha256_when_available"
    license "MIT"
  
    depends_on "git"
    depends_on "node"
    depends_on "openjdk"
    depends_on "docker"
    depends_on "helm"
    depends_on "kubectl"

    def install
      bin.install "mitchbook-dev-setup"
    end
  
    def caveats
      <<~EOS
        To complete the setup, run:
        mitchbook-dev-setup
  
        This will configure git, set up GitHub integration, configure npm,
        set up Java, docker, helm, kubectl and add useful aliases and shortcuts.
      EOS
    end
  
    test do
      assert_match "Mitchbook development setup", shell_output("#{bin}/mitchbook-dev-setup --version")
    end
  end