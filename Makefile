PROJECT := shieldproject

all: core agent store

prep:
	./build

core: prep
	docker build -t $(PROJECT)/core ./core

agent: prep
	docker build -t $(PROJECT)/agent ./agent

store: prep
	docker build -t $(PROJECT)/store ./store

live:
	docker push $(PROJECT)/core
	docker push $(PROJECT)/agent
	docker push $(PROJECT)/store

.PHONY: prep core agent store live
