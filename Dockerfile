FROM ubuntu:plucky as build
RUN apt update && apt install -y  git nodejs npm curl python3.13-venv
RUN npm install --global yarn
RUN git clone https://github.com/clickhouse/clickhouse-docs
WORKDIR clickhouse-docs
RUN yarn install && yarn build
ENV DOCUSUARUS_LOCALE=ru
RUN yarn build

FROM nginx:1.27.4-perl as runtime

COPY --from=build clickhouse-docs/build /usr/share/nginx/html/docs
COPY default.conf /etc/nginx/conf.d/default.conf