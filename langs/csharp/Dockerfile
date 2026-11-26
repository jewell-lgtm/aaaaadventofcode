FROM mcr.microsoft.com/dotnet/sdk:10.0.404-noble
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1 DOTNET_NOLOGO=1 DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1 \
    DOTNET_GENERATE_ASPNET_CERTIFICATE=false MSBUILDTERMINALLOGGER=off
# Restore + build the template once so the first real build finds everything locally.
COPY template /tmp/warm
RUN cd /tmp/warm && dotnet build -c Release && rm -rf /tmp/warm
WORKDIR /aoc
