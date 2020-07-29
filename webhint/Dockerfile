FROM alpine:edge
# Installs latest Chromium (77) package.
RUN apk add --no-cache \
   chromium \
   nss \
   freetype \
   freetype-dev \
   harfbuzz \
   ca-certificates \
   ttf-freefont \
   nodejs \
   npm
   
# Tell Puppeteer to skip installing Chrome. We’ll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
  PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
  CHROMIUM_FLAGS="--no-sandbox --headless" \
  HINT_TELEMETRY=off

RUN npm i -g puppeteer@5.2.1 hint --silent --no-warnings

RUN set -x \
  && node -v \
  && npm -v \
  && npx -v \
  && hint -v

WORKDIR hint
COPY .hintrc .
