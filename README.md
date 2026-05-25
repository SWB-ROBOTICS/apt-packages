# SWB Private APT Repository

This repository hosts pre-compiled, binary-only Debian (`.deb`) packages for SWB's internal ROS 2 deployments. Source code is excluded from these packages for security.

## Target Machine Setup

To pull packages from this repository onto a target machine or robot, follow these steps:

### 1. Configure Authentication
Create an APT auth file to store your GitHub Personal Access Token (PAT) securely:
```bash
sudo nano /etc/apt/auth.conf.d/github.conf
```

Add the following line (replace placeholders with your credentials):
```text
machine ://githubusercontent.com login <your-github-username> password <YOUR_PERSONAL_ACCESS_TOKEN>
```

Secure the file permissions:
```bash
sudo chmod 600 /etc/apt/auth.conf.d/github.conf
```

### 2. Add the Repository Source
Add this repository to your system's APT sources list:
```bash
echo "deb [trusted=yes] https://://githubusercontent.com/your-company-or-username/swb-apt-repo/main/ ./" | sudo tee /etc/apt/sources.list.d/swb-ros.list
```

### 3. Update and Install
```bash
sudo apt update
sudo apt install ros-humble-<your-package-name>
```
