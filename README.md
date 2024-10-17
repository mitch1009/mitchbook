
# MacBook Development Environment Setup 

This repo automates the setup of a development environment on macOS. It configures various tools and services commonly used by developers.

## Features

- Installs Homebrew
- Configures Git
- Sets up GPG for commit signing
- Installs and configures Docker
- Sets up GitHub integration
- Configures npm
- Installs and configures Java
- Adds useful aliases to `.zshrc`

## Prerequisites

- macOS operating system
- `setup.yml` file in the same directory as the script

## Usage

1. Create a `setup.yml` file with the following structure:

```yaml
git:
  name: "Your Name"
  email: "your.email@example.com"
```

2. Make the script executable:

```bash
chmod +x run.profile
```

3. Run the script:

```bash
./run.profile
```

## Configuration Steps

The script performs the following steps:

1. Installs Homebrew
2. Configures Git with name and email from `setup.yml`
3. Sets up GPG for commit signing and adds the key to GitHub
4. Installs and starts Docker Desktop
5. Sets up GitHub integration (SSH key and authentication)
6. Configures npm with author details
7. Installs and configures Java
8. Adds useful aliases to `.zshrc`

## Functions

- `configure_git()`: Sets up Git configuration
- `setup_gpg()`: Configures GPG for commit signing
- `configure_docker()`: Installs and starts Docker Desktop
- `setup_github()`: Sets up GitHub integration
- `configure_npm()`: Configures npm
- `configure_java()`: Installs and configures Java
- `add_aliases()`: Adds useful aliases to `.zshrc`

## Notes

- The script requires an active internet connection
- Some steps may require user interaction or password input
- Ensure you have necessary permissions to install software and modify system files
- Review the script before running to ensure it meets your specific needs

## Customization

You can modify the script to add or remove steps based on your specific requirements. Each function can be commented out or modified in the `main()` function if not needed.