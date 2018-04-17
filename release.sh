#!/bin/bash
set -xe

image_name="rbd-repo"
release_ver=${1:-master}

if [ "$release_type" == "" ];then
  echo "please input release type (community | enterprise | all )"
  exit 1
fi

function release(){
  ver=$1

  # get git describe info
  release_desc=${ver}-`git rev-parse --short master`

  sed "s/__RELEASE_DESC__/${release_desc}/" Dockerfile > Dockerfile.release

  docker build -t rainbond/${image_name}:${release_ver} -f Dockerfile.release . && rm -rf Dockerfile.release
  docker push rainbond/${image_name}:${release_ver}
}


release $release_ver
