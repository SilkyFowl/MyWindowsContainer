# MyWindowsContainer

Windows Server Container

## How to use

build image

```powershell
# base
docker build --tag core:20H2 .\core\

# server core
docker build --tag ssh:servercore-20H2 .\ssh\ServerCore\

# nano server
docker build --tag ssh:nanoserver-20H2 .\ssh\NanoServer\
```

run

```powershell
# server core
docker run  -d -it --isolation process  --rm -p 10000:22  --name ssh_servercore ssh:servercore-20H2

# nano server
docker run  -d -it --isolation process  --rm -p 11000:22  --name ssh_nanoserver ssh:nanoserver-20H2
```

ssh

```powershell
ssh ssh@localhost -p 11000     
# The authenticity of host '[localhost]:11000 ([127.0.0.1]:11000)' can't be established.
# ECDSA key fingerprint is SHA256:4fP4qn/M6dyZyMvabzS9mNrKd6jtOfUb8F/Ec6HECCs.
# Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
# Warning: Permanently added '[localhost]:11000' (ECDSA) to the list of known hosts.
ssh@localhost's password: 
```
