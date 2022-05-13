#!/bin/bash
set -e -o pipefail

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

SOURCE_IMAGE=jforge/jenkins-jnlp-slave

if [[ -n $GIT_TAG ]]; then
    TAG=${GIT_TAG/v/}
    echo "publish $TAG"
	docker tag ${SOURCE_IMAGE} ${SOURCE_IMAGE}:${TAG}
	docker tag ${SOURCE_IMAGE}:alpine ${SOURCE_IMAGE}:${TAG}-alpine
	docker tag ${SOURCE_IMAGE}:debian ${SOURCE_IMAGE}:${TAG}-debian
	docker tag ${SOURCE_IMAGE}:jdk11 ${SOURCE_IMAGE}:${TAG}-jdk11
	docker push ${SOURCE_IMAGE}:${TAG}
	docker push ${SOURCE_IMAGE}:${TAG}-alpine
	docker push ${SOURCE_IMAGE}:${TAG}-debian
	docker push ${SOURCE_IMAGE}:${TAG}-jdk11

else
    echo "publish latest"
	docker push ${SOURCE_IMAGE}
	docker push ${SOURCE_IMAGE}:alpine
	docker push ${SOURCE_IMAGE}:debian
	docker push ${SOURCE_IMAGE}:jdk11
fi