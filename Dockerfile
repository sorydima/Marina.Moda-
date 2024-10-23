
# Dockerfile for Marina.Moda®

# Use a Flutter base image
FROM cirrusci/flutter:stable

# Set working directory
WORKDIR /app

# Copy the project files
COPY . .

# Install dependencies
RUN flutter pub get

# Expose port
EXPOSE 8080

# Start the Flutter application
CMD ["flutter", "run", "--release"]
