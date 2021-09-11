#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY "WeatherAPI.csproj" "."
COPY *.sln .

#restores dependencies and tools
RUN dotnet restore "./WeatherAPI.csproj"

COPY . .
#build the project and dependencies
RUN dotnet build "./WeatherAPI.csproj" -c Release -o /app
#RUN ls -la /app/build > /app/build.txt

FROM build AS publish
RUN dotnet publish "./WeatherAPI.csproj" -c Release -o /app
#RUN ls -la /app/publish > /app/publish.txt
#RUN ls -la /app > /app/app.txt
#RUN echo "Hello World"

FROM base AS final
WORKDIR /app
COPY --from=publish /app .

ENTRYPOINT ["dotnet", "WeatherAPI.dll"]