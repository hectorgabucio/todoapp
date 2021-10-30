FROM golang:1.17

WORKDIR /usr/app

COPY . .

RUN go mod download

RUN go get github.com/cosmtrek/air
EXPOSE 8080