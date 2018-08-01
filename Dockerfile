# escape=`

FROM microsoft/dotnet-framework:4.7.2-sdk

# Copy the .NET 3.5 on demand package and Wix Build Toolset binaries
ADD microsoft-windows-netfx3-ondemand-package.cab C:\Build_Tools\microsoft-windows-netfx3-ondemand-package.cab
ADD wix311-binaries.zip C:\Build_Tools\wix311-binaries.zip

# Setting up WixToolset Path
ENV WixToolPath "C:/Build_Tools/WiX/wix311"

# Extract WixBuild Toolset
# Install and enable the feature .NET Framework 3.5 + Extract WixBuild Toolset
# Remove packages
RUN powershell -Command `
    Install-WindowsFeature –name NET-Framework-Core –source C:\Build_Tools; `
    Expand-Archive C:\Build_Tools\wix311-binaries.zip C:\Build_Tools\WiX\wix311; `
    Remove-Item C:\Build_Tools\wix311-binaries.zip -Force; ` 
    Remove-Item C:\Build_Tools\microsoft-windows-netfx3-ondemand-package.cab 

# Adding BuildAdmin user and assign as Administrator
RUN net user buildAdmin /add
RUN net localgroup administrators /add buildadmin

# Assign the user as buildadmin
USER buildadmin

# Default to PowerShell if no other command specified.
CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]