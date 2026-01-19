# Use the official NGINX image as a base
FROM nginx:alpine

# Copy your static site files into the container
COPY ./public /usr/share/nginx/html

# Expose port 80 to serve the site
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
