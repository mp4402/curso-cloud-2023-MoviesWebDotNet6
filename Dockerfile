#Stage 1: Build and publish the code

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /
COPY . .
RUN dotnet restore
WORKDIR /Movies.WebApp
RUN dotnet build -c Release

FROM build AS publish
WORKDIR /Movies.WebApp
RUN dotnet publish -c Release -o /publish


#Stage 2: Publish and run

FROM mcr.microsoft.com/dotnet/aspnet:6.0
ENV ASPNETCORE_ENVIRONMENT=Development
WORKDIR /Movies.WebApp
COPY --from=publish /publish .
EXPOSE 80
ENTRYPOINT ["./Movies.WebApp"]