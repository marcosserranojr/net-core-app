FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://*:8080

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["demo-refdoc.csproj", "./"]
RUN dotnet restore "demo-refdoc.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "demo-refdoc.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "demo-refdoc.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "demo-refdoc.dll"]
