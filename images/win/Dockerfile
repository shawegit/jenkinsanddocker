FROM microsoft/windowsservercore
MAINTAINER Simon Hawe sh@gi.ai

# Install Chocolatey
SHELL ["powershell"]
RUN Set-ExecutionPolicy -ExecutionPolicy Unrestricted
RUN $env:chocolateyUseWindowsCompression='false'; iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

# Install build tools
RUN powershell add-windowsfeature web-asp-net45; \
    choco install microsoft-build-tools -y --allow-empty-checksums; \
    choco install dotnet4.6-targetpack --allow-empty-checksums -y; \
    choco install nuget.commandline --allow-empty-checksums -y; \
    choco install cmake --allow-empty-checksums -y; \
    choco install git -params '"/GitAndUnixToolsOnPath"' --allow-empty-checksums -y; \
	choco install vcbuildtools --allow-empty-checksums -y; \
	choco install 7zip --allow-empty-checksums -y; 
	
RUN [Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\Program Files\CMake\bin;C:\Program Files (x86)\MSBuild\14.0\Bin;C:\Program Files\7-zip', [System.EnvironmentVariableTarget]::Machine) 
	
RUN iwr https://sourceforge.net/projects/boost/files/boost/1.62.0/boost_1_62_0.7z/download -UseBasicParsing -OutFile boost.7z -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::FireFox

RUN & 7z.exe x boost.7z -y
RUN & 'C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat'; \
	cd boost_1_62_0; \
	& '.\bootstrap.bat'; \
	& '.\b2' -j4 toolset=msvc-14.0 address-model=32 architecture=x86 link=static threading=multi runtime-link=shared install --with-test variant=release -d0; \
	& '.\b2' -j4 toolset=msvc-14.0 address-model=64 architecture=x86 link=static threading=multi runtime-link=shared install --with-test variant=release -d0

RUN net user jenkins /ADD
ENTRYPOINT powershell

