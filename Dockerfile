FROM golang:1.23-alpine

WORKDIR /app

# Install CompileDaemon for hot reload during development
RUN go install github.com/githubnemo/CompileDaemon@latest

# Pre-copy/cache go.mod for pre-downloading dependencies
COPY go.mod go.sum ./
RUN go mod download && go mod verify

# Copy the source code
COPY . .

# Set environment variables
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    DB_HOST=postgres \
    DB_PORT=5432 \
    DB_USER=postgres \
    DB_PASSWORD=postgres \
    DB_NAME=mydatabase

# Expose the application port
EXPOSE 3000

# Use CompileDaemon to watch for changes
CMD CompileDaemon --build="go build -o main ." --command="./main"
