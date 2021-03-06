- [Supported Tags](#orge4503b1)
  - [Simple Tags](#orgf5980dd)
  - [Shared Tags](#org3fb4e1f)
- [Quick Reference](#org6b07a7b)
- [What is ABCL?](#orgfcb571f)
- [How to use this iamge](#orge0f7852)
  - [Create a `Dockerfile` in your ABCL project](#orge6f4ae1)
  - [Run a single Common Lisp script](#org8208b8d)
  - [Developing using SLIME](#org11da1b9)
- [Image variants](#org6e3ae5b)
  - [`%%IMAGE%%:<version>`](#org630dd11)
  - [`%%IMAGE%%:<version>-slim`](#org647d810)
  - [`%%IMAGE%%:<version>-windowsservercore`](#org3cb48b6)
- [License](#orgcf4053d)



<a id="orge4503b1"></a>

# Supported Tags


<a id="orgf5980dd"></a>

## Simple Tags

INSERT-SIMPLE-TAGS


<a id="org3fb4e1f"></a>

## Shared Tags

INSERT-SHARED-TAGS


<a id="org6b07a7b"></a>

# Quick Reference

-   **ABCL Home Page:** <https://abcl.org/>
-   **Where to file Docker image related issues:** <https://gitlab.common-lisp.net/cl-docker-images/abcl/>
-   **Where to file issues for ABCL itself:** <https://github.com/armedbear/abcl/issues>
-   **Maintained by:** [CL Docker Images Project](https://common-lisp.net/project/cl-docker-images)
-   **Supported platforms:** `linux/amd64`, `linux/arm64/v8`, `windows/amd64`


<a id="orgfcb571f"></a>

# What is ABCL?

From [ABCL's Home Page](https://abcl.org)

> Armed Bear Common Lisp (ABCL) is a full implementation of the Common Lisp language featuring both an interpreter and a compiler, running in the JVM. Originally started to be a scripting language for the J editor, it now supports JSR-223 (Java scripting API): it can be a scripting engine in any Java application. Additionally, it can be used to implement (parts of) the application using Java to Lisp integration APIs.


<a id="orge0f7852"></a>

# How to use this iamge


<a id="orge6f4ae1"></a>

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


<a id="org8208b8d"></a>

## Run a single Common Lisp script

For many simple, single file projects, you may find it inconvenient to write a complete \`Dockerfile\`. In such cases, you can run a Lisp script by using the ABCL Docker image directly:

```console
$ docker run -it --rm --name my-running-script -v "$PWD":/usr/src/app -w /usr/src/app %%IMAGE%%:latest abcl --load ./your-daemon-or-script.lisp
```


<a id="org11da1b9"></a>

## Developing using SLIME

[SLIME](https://common-lisp.net/project/slime/) provides a convenient and fun environment for hacking on Common Lisp. To develop using SLIME, first start the Swank server in a container:

```console
$ docker run -it --rm --name abcl-slime -p 127.0.0.1:4005:4005 -v /path/to/slime:/usr/src/slime -v "$PWD":/usr/src/app -w /usr/src/app %%IMAGE%%:latest abcl --load /usr/src/slime/swank-loader.lisp --eval '(swank-loader:init)' --eval '(swank:create-server :dont-close t :interface "0.0.0.0")'
```

Then, in an Emacs instance with slime loaded, type:

```emacs
M-x slime-connect RET RET RET
```


<a id="org6e3ae5b"></a>

# Image variants

This image comes in several variants, each designed for a specific use case.


<a id="org630dd11"></a>

## `%%IMAGE%%:<version>`

This is the defacto image. If you are unsure about what your needs are, you probably want to use this one. It is designed to be used both as a throw away container (mount your source code and start the container to start your app), as well as the base to build other images off of.

Some of these tags may have names like buster or stretch in them. These are the suite code names for releases of Debian and indicate which release the image is based on. If your image needs to install any additional packages beyond what comes with the image, you'll likely want to specify one of these explicitly to minimize breakage when there are new releases of Debian.

This tag attempts to replicate the base environment provided by buildpack-deps. It, by design, has a large number of extremely common Debian packages.

These images contain the quicklisp installer, located at `/usr/local/share/common-lisp/source/quicklisp/quicklisp.lisp`. Additionally, there is a script at `/usr/local/bin/install-quicklisp` that will use the bundled installer to install Quicklisp. You can configure the Quicklisp install with the following environment variables:

-   **`QUICKLISP_DIST_VERSION`:** The dist version to use. Of the form yyyy-mm-dd. `latest` means to install the latest version (the default).
-   **`QUICKLISP_CLIENT_VERSION`:** The client version to use. Of the form yyyy-mm-dd. `latest` means to install the latest version (the default).
-   **`QUICKLISP_ADD_TO_INIT_FILE`:** If set to `true`, `(ql:add-to-init-file)` is used to add code to the implementation's user init file to load Quicklisp on startup. Not set by default.

Additionally, these images contain cl-launch to provide a uniform interface to running a Lisp implementation without caring exactly which implementation is being used (for instance to have uniform CI scripts).


<a id="org647d810"></a>

## `%%IMAGE%%:<version>-slim`

This image does not contain the common packages contained in the default tag and only contains the minimal packages needed to run ABCL. Unless you are working in an environment where only this image will be deployed and you have space constraints, we highly recommend using the default image of this repository.


<a id="org3cb48b6"></a>

## `%%IMAGE%%:<version>-windowsservercore`

This image is based on [Windows Server Core (`microsoft/windowsservercore`)](https://hub.docker.com/_/microsoft-windows-servercore). As such, it only works in places which that image does, such as Windows 10 Professional/Enterprise (Anniversary Edition) or Windows Server 2016.

For information about how to get Docker running on Windows, please see the relevant "Quick Start" guide provided by Microsoft:

-   [Windows Server Quick Start](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/quick_start/quick_start_windows_server)
-   [Windows 10 Quick Start](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/quick_start/quick_start_windows_10)


<a id="orgcf4053d"></a>

# License

ABCL is licensed under the [GNU GPL](https://www.gnu.org/copyleft/gpl.html) with [Classpath exception](https://www.gnu.org/software/classpath/license.html).

The Dockerfiles used to build the images are licensed under BSD-2-Clause.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
