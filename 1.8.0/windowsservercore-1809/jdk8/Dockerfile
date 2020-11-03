FROM openjdk:8-windowsservercore-1809

LABEL maintainer="etimmons@mit.edu"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV ABCL_VERSION=1.8.0
ENV ABCL_SHA512=41f2e964f0dc7a2ac715086a2bc8f58a3c816fe9b6c18a7e28ae4cd9c0ff2a8db79d6b912bbaa19e1c5175a1a97efb650d29c4eb13cc1d95ca7f85e5513d9cea


RUN $ABCL_URL=('https://abcl.org/releases/{0}/abcl-bin-{0}.zip' -f $env:ABCL_VERSION); \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    \
    Write-Host ('Downloading ABCL {0} ...' -f $ABCL_URL); \
    Invoke-WebRequest -Uri $ABCL_URL -OutFile 'abcl.zip'; \
    Write-Host ('Verifying sha512 ({0}) ...' -f $env:ABCL_SHA512); \
    if ((Get-FileHash 'abcl.zip' -Algorithm sha512).Hash -ne $env:ABCL_SHA512) { \
		Write-Host 'FAILED!'; \
		exit 1; \
    }; \
    Expand-Archive abcl.zip -DestinationPath C:\abcl-tmp; \
    Move-Item C:\abcl-tmp\abcl-bin-$env:ABCL_VERSION C:\abcl;

RUN $machineKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SYSTEM\ControlSet001\Control\Session Manager\Environment\', $true); \
    $machinePath = $machineKey.GetValue('PATH', [string]::Empty, 'DoNotExpandEnvironmentNames').ToString(); \
    $newPath = ('C:\abcl;{0}' -f $machinePath); \
    $machineKey.SetValue('PATH', $newPath, 'ExpandString'); \
    $machineKey.Close();

COPY abcl.bat C:\\abcl\\abcl.bat
CMD ["abcl.bat"]
