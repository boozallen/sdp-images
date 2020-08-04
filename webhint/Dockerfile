# Copyright © 2018 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

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
   
# Tell Puppeteer to skip installing Chrome
# Set execution path
# Browser cli configuration for root usage
# Hint feedback off to avoid erroring out no input from confirmation question
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    CHROMIUM_FLAGS="--no-sandbox --headless" \
    HINT_TELEMETRY=off

RUN npm i -g puppeteer@5.2.1 hint --silent --no-warnings

# Sanity checking - also crashes build if something didn't install correctly which we want
RUN set -x \
    && node -v \
    && npm -v \
    && npx -v \
    && hint -v
