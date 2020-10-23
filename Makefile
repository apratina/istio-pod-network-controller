default: build

# login to artifactory using artifactory credentials
login:
		@docker login -u $(ARTIFACTORY_USER) -p $(ARTIFACTORY_API_TOKEN) docker-asr-release.dr.corp.adobe.com

pre-deploy-build:
		@echo "nothing is defined in pre-deploy-build step"

post-deploy-build:
		@echo "nothing is defined in post-deploy-build step"

vendor: tools.dep
		@dep ensure -vendor-only

# builds the buildtime and runtime image
build: login
		@CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o ./bin/istio-pod-network-controller -v cmd/istio-pod-network-controller/main.go
		@chmod 755 ./bin/istio-pod-network-controller
		@docker build -t istio-pod-network-controller .

# push image
push: build
		@docker tag istio-pod-network-controller docker-asr-release.dr-uw2.adobeitc.com/test/istio-pod-network-controller:latest
		@docker push docker-asr-release.dr-uw2.adobeitc.com/test/istio-pod-network-controller:latest

# deploy vesta daemonset
deploy-ew:
		@kubectl apply -f k8s.yaml

# delete vesta daemonset
delete-ew:
		@kubectl delete -f k8s.yaml
