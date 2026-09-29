FROM nginx:1.31.6-alpine

RUN rm -f /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d/app.conf

COPY html /usr/share/nginx/html

RUN mkdir -p /etc/letsencrypt/live/api.troshin.by

EXPOSE 80 443

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
