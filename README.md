SHIELD Docker Images
====================

This repo contains the source code and definitions of the SHIELD
Project's Official Docker Images.

  - Core (**shieldproject/core**) - The SHIELD Core, which hosts
    the API, Scheduler, and Database.

  - Agent (**shieldproject/agent**) - A standalone SHIELD agent
    process, suitable for use as a sidecar or addon.

  - Store (**shieldproject/store**) - A simple, no-frills nginx
    WebDAV implementation, for demo and testing purposes.

Running the Images
------------------

### Running SHIELD Core

The SHIELD Core image configures SHIELD (`shieldd`) to listen on
TCP/80.  You usually want to expose this to the container host:

    docker run -d -p 8180:80 shieldproject/core

The SHIELD API and Web UI are now available on
http://localhost:8180.

The following environment variables affect the SHIELD Core image:

  - **SHIELD\_WORKERS** - The number of internal SHIELD worker
    threads to spin up.  Defaults to 4.

  - **SHIELD\_MAX\_TIMEOUT** - _currently undocumented_

  - **SHIELD\_SLOW\_LOOP** - The SHIELD scheduler slow-loop
    interval, in seconds.  Defaults to 300 (5 minutes).

  - **SHIELD\_FAST\_LOOP** - The SHIELD scheduler fast-loop
    interval, in seconds.  Defaults to 2.
  - **SHIELD\_SESSION\_TIMEOUT** - How long before an idle API or
    Web UI session times out and is deleted, in hours.  Defaults
    to 8.

  - **SHIELD\_DEBUG** - Whether or not to enable verbose debug
    logging in the SHIELD core.  Defaults to "no".

  - **SHELD\_ENV\_NAME** - An name for the environment, that
    SHIELD will pass through to clients accessing its API and web
    management console.  Defaults to 'dockerized'.

  - **SHIELD\_ENV\_COLOR** - You can color code your SHIELD Web
    User Interfaces! Set a hex value or other CSS-compatible color
    identifier, and the web UI will use it to colorize the
    environment name.  Defaults to 'yellow'.

  - **SHIELD\_MOTD** - A message of the day, displayed on the
    SHIELD Web UI login page.

  - **SHIELD\_FAILSAFE\_USERNAME** - Username for the default,
    failsafe user.  Defaults to 'shield'.

  - **SHIELD\_FAILSAFE\_PASSWORD** - Password for the default,
    failsafe user.  Defaults to 'shield'.

  - **SHIELDD\_OPTIONS** - Additional command-line options to pass
    to the `shieldd` executable.


### Running the SHIELD Agent

_Note: normally, you want to run the agent process inside of
another container.  How to configure that is beyond the scope of
this document.  Consult your container runtime system manual for
details._

The SHIELD Agent images configures the SHIELD Agent
(`shield-agent`) to listen on TCP/5444 (the default port).  You
usually want to expose this to the container host:

   docker run -d -p 5444:5444 shieldproject/agent

The SHIELD Agent is now available (via the SHIELD protocol) on
127.0.0.1:5444.

The agent currently requires a lot more configuration than the
other images.  The following environment variables facilitate that
configuration:

  - **SHIELD\_AGENT\_NAME** - The name of the SHIELD agent, as it
    appears in the SHIELD Core Web UI.  Defaults to 'docker1'.

  - **SHIELD\_CORE\_URL** - The full URL to the SHIELD Core that
    this agent should register with.  By default, agent
    registration is not performed.

  - **SHIELD\_AGENT\_REG\_INTERVAL** - The registration interval,
    in seconds.  This governs how often the agent will ping its
    SHIELD Core (**$SHIELD\_CORE\_URL**).  Defaults to 15.

  - **SHIELD\_AGENT\_AUTHKEY** - The authorized SHIELD Core key,
    for whitelisting the orchestration channel.  For now, this has
    to be extracted from the running SHIELD Core image, since
    there is no way to specify it.  Should be formatted like an
    OpenSSH `authorized_keys` entry.

  - **SHIELD\_AGENT\_OPTIONS** - Additional command-line flags for
    the `shield-agent` binary.


### Running the SHIELD Store

_Note: this component is optional.  It is not an integral part of
SHIELD, like the core and the agent are.  It is provided to help
set up demonstrations, and for local lab testing where you lack
external Cloud Storage._

The SHIELD Store image configures nginx, with WebDAV capabilities,
to listen on TCP/80.  You usually want to expose this to the
container host:

    docker run -d -p 8080:80 shieldproject/store

The WebDAV instance is now available on http://localhost:8080.
You will have to use the default WebDAV credentials (username:
`shield`, password: `shield`) to access it.  This WebDAV
configuration has automatic indexing turned on, so that the store
is browsable.

The following environment variables affect the SHIELD Store image:

  - **WEBDAV_USERNAME** - The username for accessing the WebDAV
    store (over HTTP Basic Auth).  Defaults to 'shield'.

  - **WEBDAV_PASSWORD** - The password for accessing the WebDAV
    store (over HTTP Basic Auth).  Defaults to 'shield'.



Building the Images
-------------------

We've tried to make this easy:

    make

If you just want to build each image individually:

    make core
    make agent
    make store
