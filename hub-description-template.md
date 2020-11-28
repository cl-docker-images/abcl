- [Supported Tags](#org0446a11)
  - [Simple Tags](#orgfe7680c)
  - [Shared Tags](#orgeb911e0)
- [Quick Reference](#org99b24ac)
- [What is ABCL?](#org1537c8b)
- [How to use this iamge](#org164f89f)
  - [Create a `Dockerfile` in your ABCL project](#org6ca2ff5)
  - [Run a single Common Lisp script](#org0d774fc)
  - [Developing using SLIME](#org4df881d)
- [Image variants](#org95c124a)
  - [`%%IMAGE%%:<version>`](#org9a12ed3)
  - [`%%IMAGE%%:<version>-slim`](#org98b4a96)
  - [`%%IMAGE%%:<version>-windowsservercore`](#orgf106c12)
- [License](#orgbad5fc3)



<a id="org0446a11"></a>

# Supported Tags


<a id="orgfe7680c"></a>

## Simple Tags

INSERT-SIMPLE-TAGS


<a id="orgeb911e0"></a>

## Shared Tags

INSERT-SHARED-TAGS


<a id="org99b24ac"></a>

# Quick Reference

-   **ABCL Home Page:** <https://abcl.org/>
-   **Where to file Docker image related issues:** <https://gitlab.common-lisp.net/cl-docker-images/abcl/>
-   **Where to file issues for ABCL itself:** <https://github.com/armedbear/abcl/issues>
-   **Maintained by:** [Eric Timmons](https://github.com/daewok)
-   **Supported platforms:** `linux/amd64`, `linux/arm64/v8`, `windows/amd64`


<a id="org1537c8b"></a>

# What is ABCL?

From [ABCL's Home Page](https://abcl.org)

> Armed Bear Common Lisp (ABCL) is a full implementation of the Common Lisp language featuring both an interpreter and a compiler, running in the JVM. Originally started to be a scripting language for the J editor, it now supports JSR-223 (Java scripting API): it can be a scripting engine in any Java application. Additionally, it can be used to implement (parts of) the application using Java to Lisp integration APIs.


<a id="org164f89f"></a>

# How to use this iamge


<a id="org6ca2ff5"></a>

## Create a `Dockerfile` in your ABCL project

```dockerfile
FROM %%IMAGE%%:latest
COPY . /usr/src/app
WORKDIR /usr/src/app
CMD [ "abcl", "--load", "./your-daemon-or-script.lisp" ]
```

You can then build and run the Docker image:

```console
$ docker build -t my-abcl-app
$ docker run -it --rm --name my-running-app my-abcl-app
```


<a id="org0d774fc"></a>

## Run a single Common Lisp script

For many simple, single file projects, you may find it inconvenient to write a complete \`Dockerfile\`. In such cases, you can run a Lisp script by using the ABCL Docker image directly:

```console
$ docker run -it --rm --name my-running-script -v "$PWD":/usr/src/app -w /usr/src/app %%IMAGE%%:latest abcl --load ./your-daemon-or-script.lisp
```


<a id="org4df881d"></a>

## Developing using SLIME

[SLIME](https://common-lisp.net/project/slime/) provides a convenient and fun environment for hacking on Common Lisp. To develop using SLIME, first start the Swank server in a container:

```console
$ docker run -it --rm --name abcl-slime -p 127.0.0.1:4005:4005 -v /path/to/slime:/usr/src/slime -v "$PWD":/usr/src/app -w /usr/src/app %%IMAGE%%:latest abcl --load /usr/src/slime/swank-loader.lisp --eval '(swank-loader:init)' --eval '(swank:create-server :dont-close t :interface "0.0.0.0")'
```

Then, in an Emacs instance with slime loaded, type:

```emacs
M-x slime-connect RET RET RET
```


<a id="org95c124a"></a>

# Image variants

This image comes in several variants, each designed for a specific use case.


<a id="org9a12ed3"></a>

## `%%IMAGE%%:<version>`

This is the defacto image. If you are unsure about what your needs are, you probably want to use this one. It is designed to be used both as a throw away container (mount your source code and start the container to start your app), as well as the base to build other images off of.

Some of these tags may have names like buster or stretch in them. These are the suite code names for releases of Debian and indicate which release the image is based on. If your image needs to install any additional packages beyond what comes with the image, you'll likely want to specify one of these explicitly to minimize breakage when there are new releases of Debian.

This tag attempts to replicate the base environment provided by buildpack-deps. It, by design, has a large number of extremely common Debian packages.


<a id="org98b4a96"></a>

## `%%IMAGE%%:<version>-slim`

This image does not contain the common packages contained in the default tag and only contains the minimal packages needed to run ABCL. Unless you are working in an environment where only this image will be deployed and you have space constraints, we highly recommend using the default image of this repository.


<a id="orgf106c12"></a>

## `%%IMAGE%%:<version>-windowsservercore`

This image is based on [Windows Server Core (`microsoft/windowsservercore`)](https://hub.docker.com/_/microsoft-windows-servercore). As such, it only works in places which that image does, such as Windows 10 Professional/Enterprise (Anniversary Edition) or Windows Server 2016.

For information about how to get Docker running on Windows, please see the relevant "Quick Start" guide provided by Microsoft:

-   [Windows Server Quick Start](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/quick_start/quick_start_windows_server)
-   [Windows 10 Quick Start](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/quick_start/quick_start_windows_10)


<a id="orgbad5fc3"></a>

# License

ABCL is licensed under the [GNU GPL](https://www.gnu.org/copyleft/gpl.html) with [Classpath exception](https://www.gnu.org/software/classpath/license.html).

The Dockerfiles used to build the images are licensed under BSD-2-Clause.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
