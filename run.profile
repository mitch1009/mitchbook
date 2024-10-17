#!/bin/bash
# Check if setup.yml exists
if [ ! -f "setup.yml" ]; then
    echo "Error: setup.yml file not found."
    echo "Please ensure setup.yml exists in the current directory."
    exit 1
fi

# instal homebrew
echo "Initial config: Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Function to configure git
configure_git() {
    echo "Configuring git..."
    git_name=$(yq eval '.git.name' setup.yml)
    git_email=$(yq eval '.git.email' setup.yml)
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    git config --global init.defaultBranch main
    echo "Git configured with name: $git_name and email: $git_email"
}

configure_docker() {
    echo "Setting up Docker..."
    
    # Check if Docker Desktop is installed
    if ! command -v docker &> /dev/null; then
        echo "Docker Desktop is not installed. Installing Docker Desktop..."
        
        # Download Docker Desktop for Mac
        curl -O https://desktop.docker.com/mac/stable/Docker.dmg
        
        # Mount the DMG file
        hdiutil attach Docker.dmg
        
        # Copy Docker to Applications
        cp -R /Volumes/Docker/Docker.app /Applications
        
        # Unmount the DMG file
        hdiutil detach /Volumes/Docker
        
        # Remove the DMG file
        rm Docker.dmg
        
        echo "Docker Desktop has been installed."
    else
        echo "Docker Desktop is already installed."
    fi
    
    # Start Docker Desktop
    open -a Docker
    
    # Wait for Docker to start
    echo "Waiting for Docker to start..."
    while ! docker info &>/dev/null; do
        sleep 1
    done
    
    echo "Docker is now running and ready to use."
}

# Function to set up GitHub integration
setup_github() {
    echo "Setting up GitHub integration..."
    ssh-keygen -t ed25519 -C "$git_email"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    # Check if gh CLI is installed
    if ! command -v gh &> /dev/null; then
        echo "GitHub CLI (gh) is not installed. Installing it now..."
        if command -v brew &> /dev/null; then
            brew install gh
        else
            echo "Homebrew is not installed. Please install Homebrew first to proceed with gh installation."
            return 1
        fi
    fi
    if ! command -v gh &> /dev/null; then
        echo "Failed to install GitHub CLI (gh). Please install it manually."
        return 1
    fi

    # Authenticate with GitHub using gh CLI
    echo "Authenticating with GitHub..."
    gh auth login -s admin:public_key

    # Add SSH key to GitHub account
    echo "Adding SSH key to GitHub account..."
    gh ssh-key add ~/.ssh/id_ed25519.pub --title "MacBook $(date +%Y-%m-%d)"

    echo "GitHub integration set up automatically using gh CLI."
}

# Function to configure npm
configure_npm() {
    echo "Configuring npm..."
    npm config set init-author-name "$git_name"
    npm config set init-author-email "$git_email"
    npm config set init-license "MIT"
    echo "npm configured."
}

# Function to configure Java
configure_java() {
    echo "Installing and configuring Java..."
    if ! command -v java &> /dev/null; then
        echo "Java is not installed. Installing it now..."
        if command -v brew &> /dev/null; then
            brew install openjdk
        else
            echo "Homebrew is not installed. Please install Homebrew first to proceed with Java installation."
            return 1
        fi
    fi
    
    if ! command -v java &> /dev/null; then
        echo "Failed to install Java. Please install it manually."
        return 1
    fi
    
    echo 'export JAVA_HOME=$(/usr/libexec/java_home)' >> ~/.zshrc
    echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.zshrc
    source ~/.zshrc
    
    java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
    echo "Java $java_version has been installed and configured."
}

# Function to add aliases and shortcuts
add_aliases() {
    echo "Adding aliases and shortcuts..."
    echo "# Custom aliases" >> ~/.zshrc
    echo "alias gs='git status'" >> ~/.zshrc
    echo "alias gc='git commit'" >> ~/.zshrc
    echo "alias gp='git push'" >> ~/.zshrc
    echo "alias gl='git log --oneline --graph --decorate'" >> ~/.zshrc
    echo "alias ll='ls -la'" >> ~/.zshrc
    source ~/.zshrc
    echo "Aliases and shortcuts added."
}

# Main function
main() {
    configure_git
    configure_docker
    setup_github
    configure_npm
    configure_java
    add_aliases
    echo "MacBook development setup complete!"
}

main