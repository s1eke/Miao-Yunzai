#!/bin/sh

# 使用传递的环境变量或默认值替换 Redis 配置中的 host 值
sed -i "s/host: .*/host: ${REDIS_HOST:-redis}/g" ./config/default_config/redis.yaml

# 启动 Node.js 应用
pnpm install
exec node app
