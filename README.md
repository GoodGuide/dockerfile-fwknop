# Dockerized fwknop server

[fwknop][] is an implementation of SPA (Single Packet Authorization), for service concealment. Think of it as a next-gen Port Knocking, which is actually secure.

This image (aims to) provide an implementation of the fwknop server process in a Docker container.

### NOTE: This is incomplete

Running this in Docker is perhaps flawed in principle. At least in the approach I wanted to take, which would run an SSH service also in Docker. Using iptables on the host to filter packets bound for Docker containers, while possible, appears to be a more complex feat than that of which fwknop is capable.

## (intended) Features:

- uses the UDP server mode, rather than passively listening via libpcap
- full GPG support

#### The container will need the `--net=host --add-cap=NET_ADMIN` options in order to be able to manipulate iptables on the host

[fwknop]: https://github.com/mrash/fwknop
