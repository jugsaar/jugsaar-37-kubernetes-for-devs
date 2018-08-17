FROM        openjdk:10.0.2-jre-slim

ENV         DEFAULT_JAVA_OPTS  -Djava.net.preferIPv4Stack=true \
                               -Djava.awt.headless=true \
                               -Djava.security.egd=file:/dev/./urandom \
                               -Xms128M \
                               -Xmx1G \
                               -XX:MetaspaceSize=128M \
                               -XX:MaxMetaspaceSize=256M \
                               -XX:+UnlockExperimentalVMOptions

ENV         JAVA_OPTS ""

# Set REMOTE_DEBUG to on to enable remote debugging
ENV         REMOTE_DEBUG   off

EXPOSE      8080 8787

USER root

RUN          true \
             && mkdir -p /app \
             && echo "Europe/Berlin" > /etc/timezone \
             && adduser \
                     --system \
                     --no-create-home \
                     --disabled-password \
                     --disabled-login \
                     --shell /bin/false \
                     app \
             && chown -R app /app \
             && chmod -R "g+rwX" /app

ADD         entry-point.sh /app/
ADD         maven/*.jar /app/

RUN         chmod +x /app/entry-point.sh

USER app

HEALTHCHECK --start-period=10s \
            --interval=10s \
            CMD curl --fail http://localhost:8080/actuator/health || exit 1

CMD         ["sh","/app/entry-point.sh"]