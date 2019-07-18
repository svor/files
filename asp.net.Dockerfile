apiVersion: 1.0.0
metadata:
  name: asp.net
projects:
  -
    name: aspnetcore-example
    source:
      type: git
      location: "https://github.com/gothinkster/aspnetcore-realworld-example-app"
components:
  -
    type: chePlugin
    id: redhat-developer/che-omnisharp-plugin/latest
    memoryLimit: 1024Mi
  -
    type: chePlugin
    id: redhat-developer/netcoredbg-theia-plugin/latest
    memoryLimit: 512Mi
  -
    type: dockerimage
    alias: dotnet
    image: mcr.microsoft.com/dotnet/core/sdk:2.2-stretch
    command: ['sleep']
    args: ['infinity']
    env:
      - name: HOME
        value: /home/user
      - name: PS1
        value: $(echo ${0})\\$
    memoryLimit: 512Mi
    endpoints:
      - name: '5000'
        port: 5000
    mountSources: true
    volumes:
      - name: dotnet
        containerPath: "/home/user"
commands:
  -
    name: install Cake
    actions:
      - type: exec
        component: dotnet
        command: "dotnet tool install -g Cake.Tool"
        workdir: ${CHE_PROJECTS_ROOT}/aspnetcore-example
  -
    name: build
    actions:
      - type: exec
        component: dotnet
        command: "$HOME/.dotnet/tools/dotnet-cake --runtime=linux-x64"
        workdir: ${CHE_PROJECTS_ROOT}/aspnetcore-example
  -
    name: re-build
    actions:
      - type: exec
        component: dotnet
        command: "$HOME/.dotnet/tools/dotnet-cake --target=Rebuild --runtime=linux-x64"
        workdir: ${CHE_PROJECTS_ROOT}/aspnetcore-example
  -
    name: run server
    actions:
      - type: exec
        component: dotnet
        command: "dotnet run --project src/Conduit/Conduit.csproj"
        workdir: ${CHE_PROJECTS_ROOT}/aspnetcore-example
