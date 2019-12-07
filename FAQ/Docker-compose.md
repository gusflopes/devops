# Docker-compose credential problem (WSL, Windows 10, Docker)
When trying to run a docker-compose file that created a network, a few volumes and containers, my script wasn't able to run on my Environment. I had no problem running it on Ubuntu 18.04 and MacOS, but it wasn't working on Windows 10/WSL Ubuntu.

The problem I got was realated to `docker-credential-desktop`.

## My Environment
I'm currently running a WSL on Windows 10. More about that on Medium or my Blog.
The Docker Desktop is installed on Windows 10 but I use it from my WSL. When I use any docker commands on WSL it actually runs on the Docker installed on my Windows 10.

## Error
Trying to run `docker-compose up -d` I was getting the following error:

```
(...)
docker.credentials.errors.InitializationError: docker-credential-desktop not installed or not available in PATH
[3279] Failed to execute script docker-compose
```

## The fix
In order to fix that I needed to change my password manager. It was hard to find a solution for my specific environment because most of the discussion I found was only available for Mac OS (using osxkeychain).

Eventually I found this [Issue](https://github.com/docker/docker-credential-helpers/issues/102) on github that solved my problem.

## Instructions

Install pass
`sudo apt-get install pass`

Download, extract, make executable, and move docker-credential-pass
`wget https://github.com/docker/docker-credential-helpers/releases/download/v0.6.0/docker-credential-pass-v0.6.0-amd64.tar.gz && tar -xf docker-credential-pass-v0.6.0-amd64.tar.gz && chmod +x docker-credential-pass && sudo mv docker-credential-pass /usr/local/bin/`

Create a new gpg2 key.
`gpg2 --gen-key`

Follow prompts from gpg2 utility

Initialize pass using the newly created key

`pass init "<Your Name>"`

Add credsStore to your docker config. This can be done with sed if you don't already have credStore added to your config or you can manually add "credStore":"pass" to the config.json.
`sed -i '0,/{/s/{/{\n\t"credsStore": "pass",/' ~/.docker/config.json`

Login to docker
`docker login`

## Updates
This post was orignally writeen on 2019/12/07.

## References
https://github.com/docker/docker-credential-helpers/issues/102

https://hackernoon.com/getting-rid-of-docker-plain-text-credentials-88309e07640d

https://www.passwordstore.org/
