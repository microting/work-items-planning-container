FROM node:22-bookworm-slim as node-env

WORKDIR /app
ARG SENTRY_AUTH_TOKEN
ARG DISABLE_SENTRY
ENV PATH /app/node_modules/.bin:$PATH
COPY eform-angular-frontend/eform-client ./
RUN apt-get update
RUN apt-get -y -q install ca-certificates
RUN yarn install
RUN yarn build
RUN if [ -n "$SENTRY_AUTH_TOKEN" ] && [ "$DISABLE_SENTRY" != "true" ]; then yarn sentrysourcemap; else echo "Sentry sourcemap upload skipped (DISABLE_SENTRY=$DISABLE_SENTRY)"; fi

FROM mcr.microsoft.com/dotnet/sdk:10.0-noble AS build-env
WORKDIR /app
ARG GITVERSION
ARG PLUGINVERSION
ARG PLUGIN2VERSION
ARG PLUGIN3VERSION
ARG PLUGIN4VERSION
ARG PLUGIN5VERSION
ARG PLUGIN6VERSION

# Copy csproj and restore as distinct layers
COPY eform-angular-frontend/eFormAPI/eFormAPI.Web ./eFormAPI.Web
COPY eform-angular-items-planning-plugin/eFormAPI/Plugins/ItemsPlanning.Pn ./ItemsPlanning.Pn
COPY eform-angular-workflow-plugin/eFormAPI/Plugins/Workflow.Pn ./Workflow.Pn
COPY eform-angular-timeplanning-plugin/eFormAPI/Plugins/TimePlanning.Pn ./TimePlanning.Pn
COPY eform-angular-greate-belt-plugin/eFormAPI/Plugins/GreateBelt.Pn ./GreateBelt.Pn
COPY eform-backendconfiguration-plugin/eFormAPI/Plugins/BackendConfiguration.Pn ./BackendConfiguration.Pn
RUN dotnet publish eFormAPI.Web -o eFormAPI.Web/out /p:Version=$GITVERSION --runtime linux-x64 --configuration Release
RUN dotnet publish ItemsPlanning.Pn -o ItemsPlanning.Pn/out /p:Version=$PLUGINVERSION --runtime linux-x64 --configuration Release
RUN dotnet publish Workflow.Pn -o Workflow.Pn/out /p:Version=$PLUGIN3VERSION --runtime linux-x64 --configuration Release
RUN dotnet publish TimePlanning.Pn -o TimePlanning.Pn/out /p:Version=$PLUGIN5VERSION --runtime linux-x64 --configuration Release
RUN dotnet publish BackendConfiguration.Pn -o BackendConfiguration.Pn/out /p:Version=$PLUGIN4VERSION --runtime linux-x64 --configuration Release
RUN dotnet publish GreateBelt.Pn -o GreateBelt.Pn/out /p:Version=$PLUGIN6VERSION --runtime linux-x64 --configuration Release

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:10.0-noble
WORKDIR /app
ARG DISABLE_SENTRY
ENV DISABLE_SENTRY=${DISABLE_SENTRY}
COPY --from=build-env /app/eFormAPI.Web/out .
RUN mkdir -p ./Plugins/ItemsPlanning.Pn
RUN mkdir -p ./Plugins/Workflow.Pn
RUN mkdir -p ./Plugins/TimePlanning.Pn
RUN mkdir -p ./Plugins/BackendConfiguration.Pn
RUN mkdir -p ./Plugins/GreateBelt.Pn
COPY --from=build-env /app/ItemsPlanning.Pn/out ./Plugins/ItemsPlanning.Pn
COPY --from=build-env /app/Workflow.Pn/out ./Plugins/Workflow.Pn
COPY --from=build-env /app/BackendConfiguration.Pn/out ./Plugins/BackendConfiguration.Pn
COPY --from=build-env /app/TimePlanning.Pn/out ./Plugins/TimePlanning.Pn
COPY --from=build-env /app/GreateBelt.Pn/out ./Plugins/GreateBelt.Pn
COPY --from=node-env /app/dist/browser wwwroot
RUN rm connection.json; exit 0

ENV DEBIAN_FRONTEND noninteractive
ENV Logging__Console__FormatterName=

RUN mkdir -p /usr/share/man/man1 && \
	apt-get update && \
	apt-get install -y -q --no-install-recommends \
		libxml2 \
		libgdiplus \
		libc6-dev \
		libreoffice-writer \
		libreoffice-core \
		fonts-liberation \
		fonts-dejavu-core \
		fonts-freefont-ttf \
		hyphen-en-us \
		openjdk-17-jre-headless && \
	apt-get -y -q remove libreoffice-gnome || true && \
	apt-get clean && \
	apt-get -y autoremove && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN adduser --home=/opt/libreoffice --disabled-password --gecos "" --shell=/bin/bash libreoffice

RUN chown -R libreoffice /app /opt/libreoffice
USER libreoffice

EXPOSE 5000 5001

ENTRYPOINT ["dotnet", "eFormAPI.Web.dll"]
