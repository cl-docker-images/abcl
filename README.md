- [Supported Tags](#orgf2a9b23)
  - [Simple Tags](#orgbd05152)
  - [Shared Tags](#orgefec492)
- [Quick Reference](#org2117a5e)
- [What is ABCL?](#org09ff687)
- [What's in the image?](#org5d421d8)
- [License](#orge571e25)



<a id="orgf2a9b23"></a>

# Supported Tags


<a id="orgbd05152"></a>

## Simple Tags

-   `1.8.0-jdk15-buster`, `1.8.0-jdk-buster`, `1.8.0-buster`, `buster`, `jdk15-buster`, `jdk-buster`
-   `1.8.0-jdk11-buster`, `jdk11-buster`
-   `1.8.0-jdk8-buster`, `jdk8-buster`
-   `1.8.0-jdk15-windowsservercore-1809`, `1.8.0-jdk-windowsservercore-1809`, `1.8.0-windowsservercore-1809`, `jdk15-windowsservercore-1809`, `jdk-windowsservercore-1809`
-   `1.8.0-jdk11-windowsservercore-1809`, `jdk11-windowsservercore-1809`
-   `1.8.0-jdk8-windowsservercore-1809`, `jdk8-windowsservercore-1809`
-   `1.8.0-jdk15-windowsservercore-ltsc2016`, `1.8.0-jdk-windowsservercore-ltsc2016`, `1.8.0-windowsservercore-ltsc2016`, `jdk15-windowsservercore-ltsc2016`, `jdk-windowsservercore-ltsc2016`
-   `1.8.0-jdk11-windowsservercore-ltsc2016`, `jdk11-windowsservercore-ltsc2016`
-   `1.8.0-jdk8-windowsservercore-ltsc2016`, `jdk8-windowsservercore-ltsc2016`


<a id="orgefec492"></a>

## Shared Tags

-   `latest`, `latest-jdk`, `latest-jdk15`, `1.8.0`, `1.8.0=jdk`, `1.8.0-jdk15`
    -   `1.8.0-jdk15-buster`
    -   `1.8.0-jdk15-windowsservercore-1809`
    -   `1.8.0-jdk15-windowsservercore-ltsc2016`
-   `latest-jdk11`, `1.8.0-jdk11`
    -   `1.8.0-jdk11-buster`
    -   `1.8.0-jdk11-windowsservercore-1809`
    -   `1.8.0-jdk11-windowsservercore-ltsc2016`
-   `latest-jdk8`, `1.8.0-jdk8`
    -   `1.8.0-jdk8-buster`
    -   `1.8.0-jdk8-windowsservercore-1809`
    -   `1.8.0-jdk8-windowsservercore-ltsc2016`
-   `1.8.0-jdk15-windowsservercore`, `1.8.0-jdk-windowsservercore`, `jdk15-windowsservercore`, `jdk-windowsservercore`, `windowsserrvercore`
    -   `1.8.0-jdk15-windowsservercore-1809`
    -   `1.8.0-jdk15-windowsservercore-ltsc2016`
-   `1.8.0-jdk11-windowsservercore`, `jdk11-windowsservercore`
    -   `1.8.0-jdk11-windowsservercore-1809`
    -   `1.8.0-jdk11-windowsservercore-ltsc2016`
-   `1.8.0-jdk8-windowsservercore`, `jdk8-windowsservercore`
    -   `1.8.0-jdk8-windowsservercore-1809`
    -   `1.8.0-jdk8-windowsservercore-ltsc2016`


<a id="org2117a5e"></a>

# Quick Reference

-   **ABCL Home Page:** <https://abcl.org/>
-   **Where to file Docker image related issues:** <https://gitlab.common-lisp.net/cl-docker-images/abcl/>
-   **Where to file issues for ABCL itself:** <https://github.com/armedbear/abcl/issues>
-   **Maintained by:** [Eric Timmons](https://github.com/daewok) and the [MIT MERS Group](https://mers.csail.mit.edu/) (i.e., this is not an official ABCL image)
-   **Supported platforms:** `linux/amd64`, `linux/arm64/v8`, `windows/amd64`


<a id="org09ff687"></a>

# What is ABCL?

From [ABCL's Home Page](https://abcl.org)

> Armed Bear Common Lisp (ABCL) is a full implementation of the Common Lisp language featuring both an interpreter and a compiler, running in the JVM. Originally started to be a scripting language for the J editor, it now supports JSR-223 (Java scripting API): it can be a scripting engine in any Java application. Additionally, it can be used to implement (parts of) the application using Java to Lisp integration APIs.


<a id="org5d421d8"></a>

# What's in the image?

This image contains ABCL binaries released by the upstream devs.


<a id="orge571e25"></a>

# License

ABCL is licensed under the [GNU GPL](https://www.gnu.org/copyleft/gpl.html) with [Classpath exception](https://www.gnu.org/software/classpath/license.html).

The Dockerfiles used to build the images are licensed under BSD-2-Clause.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
