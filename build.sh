#!/bin/sh


## INPUTS
# INPUT_REGISTRY=$1
# INPUT_BUILDARGS=$2
# INPUT_IMAGENAME=$3
# INPUT_TAG=$4
# INPUT_DOCKERFILED_PATH=$5
# INPUT_FLAG_PUSH=$6

## FUNCTION
addBuildArgs() {
  for ARG in $(echo "${INPUT_BUILDARGS}" | tr ',' '\n'); do
    BUILDPARAMS="${BUILDPARAMS} --build-arg ${ARG}"
    echo "[INFO] add-arg::${ARG}"
  done
}

sanitize() {
  if [ -z "${1}" ]; then
    >&2 echo "Unable to find the ${2}. Did you set with.${2}?"
    exit 1
  fi
}

useCustomDockerfile() {
  echo "[INFO] add-docker-path::${INPUT_DOCKERFILED_PATH}"
  BUILDPARAMS="${BUILDPARAMS} -f ${INPUT_DOCKERFILED_PATH}"
}

uses() {
  [ ! -z "${1}" ] 
}

usesBoolean() {
  [ ! -z "${1}" ] && [ "${1}" = "true" ]
}

#### MAIN
main(){
    echo "[INFO] INPUT: $INPUT_REGISTRY;$INPUT_BUILDARGS;$INPUT_IMAGENAME;$INPUT_TAG;$INPUT_DOCKERFILED_PATH;$INPUT_FLAG_PUSH"
    BUILDPARAMS="--build-arg REGISTRY=${INPUT_REGISTRY}"

    sanitize "${INPUT_IMAGENAME}" "Image Name"

    # Check PATH
    if uses "${INPUT_DOCKERFILED_PATH}"; then
        useCustomDockerfile
    fi

    # Add Args
    addBuildArgs

    # ImageName & Tag
    BUILD_TAGS=" . -t ${INPUT_REGISTRY}/webjet/${INPUT_IMAGENAME}:${INPUT_TAG} "

    # Build
    echo "[INFO] BUILD COMMAND: docker build ${BUILDPARAMS} ${BUILD_TAGS}"
    docker build ${BUILDPARAMS} ${BUILD_TAGS}
    echo "[SUCCESS] Built: ${INPUT_REGISTRY}/webjet/${INPUT_IMAGENAME}:${INPUT_TAG}"

    # Push
    echo "[INFO] CHECK PUSH FLAG: ${INPUT_FLAG_PUSH}"
    if usesBoolean "${INPUT_FLAG_PUSH}"; then
        PUSH_BODY="${INPUT_REGISTRY}/webjet/${INPUT_IMAGENAME}:${INPUT_TAG}"
        echo "[INFO] PUSH IMAGE : docker push ${PUSH_BODY}"
        docker push ${PUSH_BODY}
    fi

}


main
