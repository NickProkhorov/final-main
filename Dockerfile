FROM golang:1.24 AS build
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -trimpath -ldflags "-s -w" -o /final-app .

FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY --from=build /final-app /final-app
USER nonroot:nonroot
ENTRYPOINT ["/final-app"]
