# Use the ASP.NET Core runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Use the SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["MyDotNetApp.csproj", "."]
RUN dotnet restore "MyDotNetApp.csproj"
COPY . .
RUN dotnet build "MyDotNetApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MyDotNetApp.csproj" -c Release -o /app/publish

# Final stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MyDotNetApp.dll"]
EOF