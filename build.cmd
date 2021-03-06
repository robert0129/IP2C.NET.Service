: configuration
SET BUILD_VERSION=1.0.0


: init
Tools\nuget.exe restore


: build solutions in release mode
"c:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe" /p:Configuration=Release /p:DeployOnBuild=true


: build webapi docker image
pushd .
cd IP2C.WebAPI\obj\Release\Package\PackageTmp
docker build -t ip2c/webapi:latest .
popd


: build worker docker image
pushd .
cd IP2C.Worker\bin\Release
docker build -t ip2c/worker:latest .
popd


: build & push nuget package
Tools\nuget.exe pack IP2C.SDK\IP2C.SDK.csproj -Properties Configuration=Release -Version %BUILD_VERSION%


: build complete
