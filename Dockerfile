FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://*:8080

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["netcore3.csproj", "./"]
RUN dotnet restore "netcore.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "netcore3.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "netcore3.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "netcore3.dll"]
