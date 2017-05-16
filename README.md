# Docker image with GoCD server

[GoCD server](https://www.gocd.io/ - Simplify Continuous Delivery

Open source continuous delivery server to model and visualize complex workflows with ease.

## Usage

Start the container with this:

```bash
docker run -d -p 8153:8153 -p8154:8154 --name gocd-server showtimeanalytics/gocd-server:17.4.0
```

This will expose container ports 8153(http) and 8154(https) onto your server.
You can now open `http://localhost:8153` and `https://localhost:8154`

## Available configuration options

### Mounting volumes

The GoCD server will store all configuration, pipeline history database,
artifacts, plugins, and logs into `/godata`. If you'd like to provide secure
credentials like SSH private keys among other things, you can mount `/home/go`

```bash
docker run -v /path/to/godata:/data gocd/gocd-server
```

> **Note:** Ensure that `/data` is accessible by the `gocd` user in container (`gocd` user - uid 10014).

### Installing plugins

All plugins can be installed under `/godata`.

```
mkdir -p /data/plugins/external
curl --location --fail https://example.com/plugin.jar > /odata/plugins/external/plugin.jar
chown -R 10014 /data/plugins
```

### Installing addons

All addons can be installed under `/godata`.

```
mkdir -p /data/addons
curl --location --fail https://example.com/addon.jar > /data/addons/plugin.jar
chown -R 10014 /data/addons
```

### Tweaking JVM options (memory, heap etc)

JVM options can be tweaked using the environment variable `GO_SERVER_SYSTEM_PROPERTIES`.

```bash
docker run -e GO_SERVER_SYSTEM_PROPERTIES="-Xmx4096mb -Dfoo=bar" gocd/gocd-server

If you want to specify memory limits directly, you can set up these envitonment variables with the values you prefer:

```bash
SERVER_MEM="512m"
SERVER_MAX_MEM="1024m"
SERVER_MAX_PERM_GEN="256m"
```

## Under the hood

The GoCD server runs as the `go` user, the location of the various directories is:

| Directory           | Description                                                                      |
|---------------------|----------------------------------------------------------------------------------|
| `/data/addons`      | the directory where GoCD addons are stored                                       |
| `/data/artifacts`   | the directory where GoCD artifacts are stored                                    |
| `/data/config`      | the directory where the GoCD configuration is store                              |
| `/data/db`          | the directory where the GoCD database and configuration change history is stored |
| `/data/logs`        | the directory where GoCD logs will be written out to                             |
| `/data/plugins`     | the directory containing GoCD plugins                                            |
| `/opt/gocd`         | the home directory for the GoCD server                                           |

## Determine Server IP and Ports on Host

Once the GoCD server is up, we should be able to determine its ip address and the ports mapped onto the host by doing the following:
The IP address and ports of the GoCD server in a docker container are important to know as they will be used by the GoCD agents to connect to it.
If you have started the container with
```bash
$ docker run --name gocd-server -it -p8153:8153 -p8154:8154 gocd/gocd-server:v17.3.0
```

Then, the below commands will determine to GoCD server IP, server port and ssl port
```bash
$ docker inspect --format='{{(index (index .NetworkSettings.IPAddress))}}' gocd-server
$ docker inspect --format='{{(index (index .NetworkSettings.Ports "8153/tcp") 0).HostPort}}' gocd-server
$ docker inspect --format='{{(index (index .NetworkSettings.Ports "8154/tcp") 0).HostPort}}' gocd-server
```

## Troubleshooting

### The GoCD server does not come up

- Check if the docker container is running `docker ps -a`
- Check the STDOUT to see if there is any output that indicates failures `docker logs CONTAINER_ID`
- Check the server logs `docker exec -it CONTAINER_ID tail -f /godata/logs/go-server.log` (or check the log file in the volume mount, if you're using one)

## Acknowledgments

- [GoCD official repository](https://github.com/gocd/docker-gocd-server) (documentation is based on it)
