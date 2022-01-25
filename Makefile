build:
	docker build -t garethjevans/cnb-update-dependency .

size: build
	docker image inspect garethjevans/cnb-update-dependency:latest
