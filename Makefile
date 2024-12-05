build: 
		docker build -t flutter-docker .

start:
		docker run -p 3000:8080 -it -v ./app:/home/flutteruser/app flutter-docker

sdevice:
			docker run --device /dev/bus/usb:/dev/bus/usb -v $(pwd):/app -it flutter-docker

all:	build start	