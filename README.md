docker-squid
============

A [Docker](http://www.docker.com/) image for building an authenticated,
non-caching forward proxy using [Squid](http://www.squid-cache.org/).

First of all, use the `htdigest` program from the `apache2-utils` package
to add users:

    $ htdigest conf/passwd SurfinUSA myuser
    Adding user myuser in realm SurfinUSA
    New password:
    Re-type new password:
    $ 

The realm `SurfinUSA` has to match the realm set in `conf/squid.conf`.

From the project directory you can build and tag the image:

    $ sudo docker build -t my-squid .

Use the built image to create a container and run it:

    $ sudo docker run \
       --detach \
       --name=squid \
       --user=proxy \
       --publish=4712:3128 \
       --volume=/tmp/log/squid/:/var/log/squid3/ \
       my-squid

Since Squid doesn't need to bind to a privileged port, there's no point
in granting it root rights (that it would drop immediately, anyway). We
use Squid's default port 3128 inside the container and bind it to a
different one on the host.

Note the volume switch: We map Squid's log directoy to a directory on
the host to get convenient access to the proxy's log files. The directory
on the host has to be writeable by the container's proxy user!

You could also map the `/etc/squid3/` to the host's filesystem. That way,
you can add new users or play with the configuration without needing to
build a new image. Sending a HUP signal from the host to the Squid process
will cause Squid to re-read its configuration.
