#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
FROM openjdk:11-jdk-windowsservercore-ltsc2016

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV ABCL_VERSION 1.7.0
ENV ABCL_SHA256 0be70da90f95eb3fe9f5ad5c6d2859cc30ca82eb371fc85adf0cd97f1ec5cdd9

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
    $machineKey.Close();

COPY abcl.bat C:\\abcl\\abcl.bat
CMD ["abcl.bat"]
