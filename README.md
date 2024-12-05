# flutter_dev_env
Dockerfile permettant de creer un environnement de developpement pour flutter

Usage:
`make build`: to build the docker image
`make start`: to run the docker with port 3000 associated to 8080
`make`: to run build and start

run `flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0` in the docker to access to the app with  a browser at localhost:3000
