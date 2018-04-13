---
title: "SSH (Remote) Tunnels"
date: 2011-01-02T12:36:58-04:00
tags:
  - SSH
  - Networking
  - NAT
  - Firewall
---

Just figured out how SSH remote tunnels work and wanted to write it down.

Nomenclature:

* _[Local] Client_: your local computer. In fact, if I say local, I mean the client.
* _[Remote] Server_: the server you connect to. If I say remote, I mean server.

### Forward Tunnels
Your standard tunnel, allows you to take a local port and redirect it to a remote port on the server:

```
$ ssh -L REMOTEPORT:client:CLIENTPORT user@server
```

Now, that by opening a tunnel in this way:

```
$ ssh -L 4040:localhost:8080 user@server
```

You can now connect to `localhost:8080` and you'll get, through the tunnel, what's on `server:4040`.

### Remote Tunnels

Regular forward tunnels are neat if you want to access a service that runs on a forbidden port through a firewall. But what if you need to map an incoming port on a remote server to a local port? Maybe because your ISP doesn't allow you NAT arbitrary ports?

Do not fear, remote tunnels are here for your rescue. They work pretty much the same way as regular tunnels, just the other way round. Instead of opening a listening socket on your local box, they open a port on the remote server. So, to open a port on your remote box and forward it to a local port, use the following:

```
$ ssh -R REMOTEPORT:client:CLIENTPORT user@server
```
That's it. Well, almost. There's a catch. Per default sshd will now bind the listening socket to the loopback device. Kind of useless if you want to forward incoming connections through the tunnel. If you study the man page, you'll notice that you can specify a binding port for the remote tunnel:

```
$ ssh -R BIND_ADDRESS:REMOTEPORT:client:CLIENTPORT user@server
```
So, if your server's IP was `12.23.34.45`, you would specify:

```
$ ssh -R 12.23.34.45:8080:localhost:8080 user@server
```
However, depending on your sshd configuration it might or might not work. Per default sshd won't let you just bind sockets to anything. You'll need to allow that, by specifying the GatewayPorts option in your `sshd_config` and restart sshd:

```
GatewayPorts yes
```
I got slightly confused, as the man page states that you can specify a value `clientspecified` to allow the client to select a specific interface, but it didn't work for me.

