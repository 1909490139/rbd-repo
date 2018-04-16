#!/bin/bash
set -xe

image_name="acp_repo"
release_type=$1

if [ "$release_type" == "" ];then
  echo "please input release type (community | enterprise | all )"
  exit 1
fi

function release(){
  release_type=$1
  release_ver=`grep ${release_type} VERSION | awk '{print $2}'`
  branch_name=${release_type}-${release_ver}
  git checkout $branch_name

  # get git describe info
  release_desc=${branch_name}-`git rev-parse --short $branch_name`

  sed "s/__RELEASE_DESC__/${release_desc}/" Dockerfile > Dockerfile.release

  docker build -t hub.goodrain.com/dc-deploy/${image_name}:${release_ver} -f Dockerfile.release . && rm -rf Dockerfile.release
  docker push hub.goodrain.com/dc-deploy/${image_name}:${release_ver}
}

case $release_type in
"community")
    release $1
    ;;
"enterprise")
    release $1
    ;;
"all")
    release "community"
    release "enterprise"
    ;;
esac
