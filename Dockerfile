# Use the official Nginx image from the Docker Hub
FROM nginx:latest

# Declare a build argument that changes for each build
ARG CACHEBUST=1

# Replace the content of index.html with 'Hello' followed by the current timestamp
RUN echo "Hello - $(TZ='Asia/Shanghai' date)" > /usr/share/nginx/html/index.html