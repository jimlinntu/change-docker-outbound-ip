FROM alpine:3.12.3
RUN apk update
RUN apk add iptables
RUN apk add bash
RUN apk add ipcalc
