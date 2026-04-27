FROM mcr.microsoft.com/dotnet/sdk:8.0 AS builder

WORKDIR /app

COPY csharp.csproj .

RUN dotnet restore

COPY Program.cs .

RUN dotnet publish -c Release -o /out

FROM mcr.microsoft.com/dotnet/runtime:8.0

WORKDIR /app

COPY --from=builder /out .

EXPOSE 8087

CMD ["dotnet", "csharp.dll"]
