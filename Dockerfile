FROM node:14.17.6 as node-env
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY eform-angular-frontend/eform-client ./
RUN npm install
RUN npm run build

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
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
COPY eform-angular-work-orders-plugin/eFormAPI/Plugins/WorkOrders.Pn ./WorkOrders.Pn
COPY eform-angular-workflow-plugin/eFormAPI/Plugins/Workflow.Pn ./Workflow.Pn
COPY eform-angular-timeplanning-plugin/eFormAPI/Plugins/TimePlanning.Pn ./TimePlanning.Pn
COPY eform-angular-greate-belt-plugin/eFormAPI/Plugins/GreateBelt.Pn ./GreateBelt.Pn
COPY eform-backendconfiguration-plugin/eFormAPI/Plugins/BackendConfiguration.Pn ./BackendConfiguration.Pn
RUN dotnet publish eFormAPI.Web -o eFormAPI.Web/out /p:Version=$GITVERSION --runtime linux-x64 --configuration Release
RUN dotnet publish ItemsPlanning.Pn -o ItemsPlanning.Pn/out /p:Version=$PLUGINVERSION --runtime linux-x64 --configuration Release
RUN dotnet publish WorkOrders.Pn -o WorkOrders.Pn/out /p:Version=$PLUGIN2VERSION --runtime linux-x64 --configuration Release
RUN dotnet publish Workflow.Pn -o Workflow.Pn/out /p:Version=$PLUGIN3VERSION --runtime linux-x64 --configuration Release
RUN dotnet publish TimePlanning.Pn -o TimePlanning.Pn/out /p:Version=$PLUGIN5VERSION --runtime linux-x64 --configuration Release
RUN dotnet publish BackendConfiguration.Pn -o BackendConfiguration.Pn/out /p:Version=$PLUGIN4VERSION --runtime linux-x64 --configuration Release
RUN dotnet publish GreateBelt.Pn -o GreateBelt.Pn/out /p:Version=$PLUGIN6VERSION --runtime linux-x64 --configuration Release

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/eFormAPI.Web/out .
RUN mkdir -p ./Plugins/ItemsPlanning.Pn
RUN mkdir -p ./Plugins/WorkOrders.Pn
RUN mkdir -p ./Plugins/Workflow.Pn
RUN mkdir -p ./Plugins/TimePlanning.Pn
RUN mkdir -p ./Plugins/BackendConfiguration.Pn
RUN mkdir -p ./Plugins/GreateBelt.Pn
COPY --from=build-env /app/ItemsPlanning.Pn/out ./Plugins/ItemsPlanning.Pn
COPY --from=build-env /app/WorkOrders.Pn/out ./Plugins/WorkOrders.Pn
COPY --from=build-env /app/Workflow.Pn/out ./Plugins/Workflow.Pn
COPY --from=build-env /app/BackendConfiguration.Pn/out ./Plugins/BackendConfiguration.Pn
COPY --from=build-env /app/TimePlanning.Pn/out ./Plugins/TimePlanning.Pn
COPY --from=build-env /app/GreateBelt.Pn/out ./Plugins/GreateBelt.Pn
COPY --from=node-env /app/dist wwwroot
RUN rm connection.json; exit 0

ENV DEBIAN_FRONTEND noninteractive

RUN mkdir -p /usr/share/man/man1mkdir -p /usr/share/man/man1
RUN apt-get update && \
	apt-get -y -q install \
		libxml2 \
		libgdiplus \
		libc6-dev \
		libreoffice \
		libreoffice-writer \
		ure \
		libreoffice-java-common \
		libreoffice-core \
		libreoffice-common \
		fonts-opensymbol \
		hyphen-fr \
		hyphen-de \
		hyphen-en-us \
		hyphen-it \
		hyphen-ru \
		fonts-dejavu \
		fonts-dejavu-core \
		fonts-dejavu-extra \
		fonts-droid-fallback \
		fonts-dustin \
		fonts-f500 \
		fonts-fanwood \
		fonts-freefont-ttf \
		fonts-liberation \
		fonts-lmodern \
		fonts-lyx \
		fonts-sil-gentium \
		fonts-texgyre \
		fonts-tlwg-purisa && \
	apt-get -y -q remove libreoffice-gnome && \
	apt -y autoremove && \
	rm -rf /var/lib/apt/lists/*

RUN adduser --home=/opt/libreoffice --disabled-password --gecos "" --shell=/bin/bash libreoffice

ENTRYPOINT ["dotnet", "eFormAPI.Web.dll"]
