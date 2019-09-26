# 使用node稳定版作为基础镜像
FROM node:lts-alpine

# 安装nginx
RUN apt-get update \
    && apt-get install -y nginx

# 如果你在国内，这行配置很有必要，不然打包会非常非常慢。
RUN npm config set registry https://registry.npm.taobao.org

# 制定工作目录
WORKDIR /app

# 将当前目录下的所有文件拷贝到工作目录下
COPY . /app/

# 声明运行时容器提供服务的端口
EXPOSE 80

# 1、安装依赖
# 2、运行npm run build
# 3、将dist目录的所有文件拷贝到nginx的目录下
# 4、 删除工作目录的文件，尤其是node_modules，以减小体积
# 5、由于镜像构建的每一步都会产生新层，为了减小镜像体积，尽可能将一些同类操作，集成到一个步骤中，如下
RUN npm install \
    && npm run build \
    && cp -r dist/* /var/www/html \
    && rm -rf /app

# 以前台方式启动nginx
CMD ["nginx","-g","daemon off;"]