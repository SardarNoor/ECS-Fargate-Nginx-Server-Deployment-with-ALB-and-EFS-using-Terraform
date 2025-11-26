FROM nginx:latest

# Copy your html folder into container image
COPY ./html /usr/share/nginx/html

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Run script instead of default nginx
CMD ["/start.sh"]
