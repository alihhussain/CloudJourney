Here's how you can SSH into this Jenkins server and set up a connection from your laptop:

### Step 1: Generate SSH Key Pair on Your Laptop
Open a terminal on your laptop and use the following command to generate an SSH key pair. When prompted, you can press Enter to use the default file location and create the key without a passphrase for simplicity, although using a passphrase is recommended for increased security.

```bash
ssh-keygen -t rsa -b 4096
```

### Step 2: Copy the Public Key to the Jenkins Server
Now you need to copy the public key to the Jenkins server. This can typically be done using the `ssh-copy-id` command. Replace `your_public_key.pub` with the path to your public key if it's not the default (`~/.ssh/id_rsa.pub`).

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub cloudjourney@13.92.174.135
```

You will be prompted to enter the password for `azureuser` the first time you do this.

### Step 3: SSH into the Jenkins Server
Once the key is added, you can SSH into the server without a password:

```bash
ssh cloudjourney@13.92.174.135
```

### Step 4: Verify Connection
To ensure the connection is established, you should now be logged into the Jenkins server. You can try running a simple command like `ls` or `pwd` to check if you're in the right user directory.

To add a new user on the Jenkins server and enable SSH key-based authentication for this user, follow these additional steps after you've successfully logged into the Jenkins server as `azureuser`.

### Step 5: Create a New User on the Jenkins Server
Once logged into the Jenkins server, you can create a new user. Let’s call this new user `jenkinsuser`. You'll need sudo privileges to do this:

```bash
sudo adduser YOURNAMEuser "Select UserName"
```

You'll be prompted to enter and confirm a new password for `jenkinsuser` and optionally fill in some additional information.

### Step 6: Set Up SSH Key Access for the New User
Next, set up the SSH key that you created on your local machine to be used for SSH access with `jenkinsuser`.

1. **Create the SSH Directory for the New User:**
   ```bash
   sudo mkdir /home/jenkinsuser/.ssh
   ```

2. **Copy the Authorized Keys File:**
   This step assumes you've already added your public key to the `azureuser`'s `authorized_keys`. You'll copy this file to the new user's `.ssh` directory to allow the same key to be used.
   ```bash
   sudo cp ~/.ssh/authorized_keys /home/jenkinsuser/.ssh/
   ```

3. **Set Correct Permissions:**
   It’s crucial to ensure that the `.ssh` directory and files have the correct permissions and ownership.
   ```bash
   sudo chown -R jenkinsuser:jenkinsuser /home/jenkinsuser/.ssh
   sudo chmod 700 /home/jenkinsuser/.ssh
   sudo chmod 600 /home/jenkinsuser/.ssh/authorized_keys
   ```

### Step 7: SSH into the Jenkins Server as the New User
Now, from your local machine, try to SSH into the server using the new user account to confirm that everything is set up correctly:
```bash
ssh cloudjourney@13.92.174.135
```

### Step 8: Configure Local Git Environment (If Required)
If you plan to use the same SSH keys for GitHub as well, you should add your public SSH key to your GitHub account:

1. Open the public key file with a text editor and copy the contents.
2. Go to your GitHub account settings.
3. Navigate to "SSH and GPG keys".
4. Click on "New SSH key", paste your public key, and save.

To configure your local Git environment to use this SSH key with GitHub, you can set the SSH key in your Git config:

```bash
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
```

Set the SSH key to be used with GitHub:
```bash
git config --global core.sshCommand "ssh -i ~/.ssh/id_rsa"
```
scp -r /path/to/local/directory username@remote-server-ip:/path/to/remote/directory/
example scp -r /c/Users/CloudJourney/.ssh/ mruser@4.246.167.105:/home/mruser/.ssh/

### Step 9: Secure the Private Key
Ensure your private key (`~/.ssh/id_rsa` by default) is kept secure and private. Set the correct permissions if not already set:

```bash
chmod 600 ~/.ssh/id_rsa
```

This sequence of steps will help you to securely connect to your Jenkins server using SSH and set up your local Git environment for GitHub commits.
