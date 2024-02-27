FROM ubuntu:20.04 as builder
ARG DEBIAN_FRONTEND=noninteractive
ENV NODE_OPTIONS "--max_old_space_size=2048"

WORKDIR /app

RUN apt update && apt install -y curl nodejs npm && npm install n -g && n 16.14.2 && apt purge -y nodejs npm && apt autoremove -y
RUN apt install -y build-essential

COPY . .
RUN npm config set unsafe-perm true
RUN npm install && npm run build

FROM ubuntu:20.04 as release
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# add apl user/group
RUN groupadd -g 1000 apl \
 && useradd -g apl -s /bin/bash -u 1000 -p apl apl \
 && echo 'apl ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN apt update && apt install -y curl tzdata && apt autoremove -y
RUN apt update && apt install -y curl nodejs npm && npm install n -g && n 16.14.2 && apt purge -y nodejs npm && apt autoremove -y
RUN apt install -y build-essential

COPY --chown=apl:apl run.sh /app/
COPY --chown=apl:apl tsconfig.json /app/

COPY --from=builder --chown=apl:apl /app/package.json /app/
COPY --from=builder --chown=apl:apl /app/package-lock.json /app/
RUN npm ci --only=prod

COPY --from=builder --chown=apl:apl /app/.bin /app/.bin/

COPY --from=builder --chown=apl:apl /app/run.sh /app/
COPY --from=builder --chown=apl:apl /app/.bin /app/.bin/
RUN chown -R apl:apl /app && chmod -R 755 /app/

ENV NODE_OPTIONS "--max_old_space_size=1280"

USER apl
WORKDIR /app
CMD ["node", "./bin/index.js"]