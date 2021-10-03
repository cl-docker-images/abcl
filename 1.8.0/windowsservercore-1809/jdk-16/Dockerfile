#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
FROM openjdk:16-jdk-windowsservercore-1809

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV ABCL_VERSION 1.8.0
ENV ABCL_SHA256 f1404556a80ae65c9f0d3c41c910b72eacaedba2929901d06d609245addb7ec8

RUN $ABCL_URL=('https://abcl.org/releases/{0}/abcl-bin-{0}.zip' -f $env:ABCL_VERSION); \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    \
    Write-Host ('Downloading ABCL {0} ...' -f $ABCL_URL); \
    Invoke-WebRequest -Uri $ABCL_URL -OutFile 'abcl.zip'; \
    Write-Host ('Verifying sha256 ({0}) ...' -f $env:ABCL_SHA256); \
    if ((Get-FileHash 'abcl.zip' -Algorithm sha256).Hash -ne $env:ABCL_SHA256) { \
		Write-Host 'FAILED!'; \
		exit 1; \
    }; \
    Expand-Archive abcl.zip -DestinationPath C:\abcl-tmp; \
    Move-Item C:\abcl-tmp\abcl-bin-$env:ABCL_VERSION C:\abcl; \
    $machineKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SYSTEM\ControlSet001\Control\Session Manager\Environment\', $true); \
    $machinePath = $machineKey.GetValue('PATH', [string]::Empty, 'DoNotExpandEnvironmentNames').ToString(); \
    $newPath = ('C:\abcl;{0}' -f $machinePath); \
    $machineKey.SetValue('PATH', $newPath, 'ExpandString'); \
    $machineKey.Close(); \
    java -jar C:\abcl\abcl.jar --batch --eval '(print (multiple-value-list (lisp-implementation-version)))'

COPY abcl-wrapper.bat C:\\abcl\\abcl.bat
CMD ["abcl.bat"]
