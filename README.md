# Dockerized fwknop server

[fwknop][] is an implementation of SPA (Single Packet Authorization), for service concealment. Think of it as a next-gen Port Knocking, which is actually secure.

This image provides an implementation of the fwknop server process in a Docker container.

Features:

- uses the UDP server mode, rather than passively listening via libpcap
- full GPG support

#### The container will need the `--net=host --add-cap=NET_ADMIN` options in order to be able to manipulate iptables on the host

[fwknop]: https://github.com/mrash/fwknop
