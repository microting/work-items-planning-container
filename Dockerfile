FROM node:14.16.1 as node-env
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY eform-angular-frontend/eform-client ./
RUN npm install
RUN npm run build

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /app
ARG GITVERSION
ARG PLUGINVERSION
ARG PLUGIN2VERSION

# Copy csproj and restore as distinct layers
COPY eform-angular-frontend/eFormAPI/eFormAPI.Web ./eFormAPI.Web
COPY eform-angular-items-planning-plugin/eFormAPI/Plugins/ItemsPlanning.Pn ./ItemsPlanning.Pn
COPY eform-angular-items-planning-plugin/eFormAPI/Plugins/WorkOrders.Pn ./WorkOrders.Pn
RUN dotnet publish eFormAPI.Web -o eFormAPI.Web/out /p:Version=$GITVERSION --runtime linux-x64 --configuration Release
RUN dotnet publish ItemsPlanning.Pn -o ItemsPlanning.Pn/out /p:Version=$PLUGINVERSION --runtime linux-x64 --configuration Release
RUN dotnet publish WorkOrders.Pn -o WorkOrders.Pn/out /p:Version=$PLUGIN2VERSION --runtime linux-x64 --configuration Release

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build-env /app/eFormAPI.Web/out .
RUN mkdir -p ./Plugins/ItemsPlanning.Pn
COPY --from=build-env /app/ItemsPlanning.Pn/out ./Plugins/ItemsPlanning.Pn
COPY --from=node-env /app/dist wwwroot
RUN rm connection.json; exit 0

ENTRYPOINT ["dotnet", "eFormAPI.Web.dll"]
