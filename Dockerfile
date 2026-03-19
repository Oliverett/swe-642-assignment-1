FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY ./index.html /usr/share/nginx/html/
COPY ./zipcodes.json /usr/share/nginx/html/
COPY ./profile.jpg /usr/share/nginx/html/

# Ensure nginx can read the files
RUN chmod 644 /usr/share/nginx/html/*

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]