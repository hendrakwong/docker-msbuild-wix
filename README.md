
# Docker Image: MSBuild with WiX Toolset

## Overview
This docker image is created based on "microsoft/dotnet-framework:4.7.2-sdk" and is used for build .NET project that utilizing WiX Build Toolset in CI build pipeline. WiX Build Toolset contains the library to generate msi installer package. 

Current WiX Build Toolset version included: v3.11.

## Usage
* Docker Base Image: dotnet-framework-wix:4.7.2-sdk
* Docker Registry: docker-dev.phibred.com
* Default User: buildadmin (Groups: Administrators)
    * __Notes:__ Grant mounted folders to "Administrators" group when executing commands inside the container.
* Custom Script in Build Step:
    ```powershell
    NuGet.exe restore <your solution name.sln> -Source <your nuget repository url>
    msbuild.exe <your solution name.sln> /t:Clean,Build /p:Configuration=<your configuration name> /p:GenerateSerializationAssemblies=Off
    ```
* In your WiX Project (*.wixproj) file, please include the following configuration:
    ``` xml
    <WixTargetsPath Condition=" '$(WixTargetsPath)' == '' AND '$(WixToolPath)' != '' ">$(WixToolPath)\Wix.targets</WixTargetsPath>
    <WixTargetsPath Condition=" '$(WixTargetsPath)' == '' ">$(MSBuildExtensionsPath)\Microsoft\WiX\v3.x\Wix.targets</WixTargetsPath>
    <WixTasksPath Condition=" '$(WixTasksPath)' == '' AND '$(WixToolPath)' != '' ">$(WixToolPath)\WixTasks.dll</WixTasksPath>
    ```