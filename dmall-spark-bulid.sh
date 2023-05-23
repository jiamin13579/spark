SRC_HOME=./
MVN_PROFILE=hive,hive-thriftserver,kubernetes,volcano,scala-2.12

cd $SRC_HOME

# java.lang.StackOverflowError  需要调整堆栈

# 源码编译
./dev/make-distribution.sh --pip --mvn ./build/mvn -T 4C -P$MVN_PROFILE -DskipTests

# docker构建需要替换镜像地址
# sed -i 's@/archive.ubuntu.com/@/mirrors.aliyun.com/@g' /etc/apt/sources.list && \
# sed -i 's@/deb.debian.org/@/mirrors.aliyun.com/@g' /etc/apt/sources.list && \
cd dist

DOCKER_REG=reg-docker.dmall.com:8066/dmall_uup \
DOCKER_TAG=3.3.2_11_2.12-base \
DOCKER_JAVA=11-jre-slim

./bin/docker-image-tool.sh -r $DOCKER_REG -t $DOCKER_TAG -b java_image_tag=$DOCKER_JAVA \
    -p kubernetes/dockerfiles/spark/bindings/python/Dockerfile \
    -f kubernetes/dockerfiles/spark/Dockerfile \
    build 
    
./bin/docker-image-tool.sh -r $DOCKER_REG -t $DOCKER_TAG push
