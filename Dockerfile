#Stage 1: Build app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /
COPY . .
RUN dotnet restore
WORKDIR /Movies.WebApp
RUN dotnet build -c Release

#Stage 2: Publish app
FROM build AS publish
WORKDIR /Movies.WebApp
RUN dotnet publish -c Release -o /publish

#Stage 3: Run app
FROM mcr.microsoft.com/dotnet/aspnet:6.0
ENV ASPNETCORE_ENVIRONMENT=Development
ENV ConnectionStrings__DbConnection="Data Source=Movies.db"
WORKDIR /Movies.WebApp
COPY --from=publish /publish .
COPY Movies.db .
EXPOSE 80
ENTRYPOINT ["./Movies.WebApp"]