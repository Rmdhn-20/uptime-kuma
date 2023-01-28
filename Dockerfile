FROM louislam/uptime-kuma:base-debian AS build
WORKDIR /app

# Copy app files from build layer
COPY --from=build /app /app

EXPOSE 3001
VOLUME ["/app/data"]
HEALTHCHECK --interval=60s --timeout=30s --start-period=180s --retries=5 CMD extra/healthcheck
ENTRYPOINT ["/usr/bin/dumb-init", "--", "extra/entrypoint.sh"]

CMD ["node", "server/server.js"]
