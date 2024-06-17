FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://*:8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["netcore8.csproj", "./"]
RUN dotnet restore "netcore8.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "netcore8.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "netcore8.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "netcore8.dll"]
