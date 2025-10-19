#!/bin/bash
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" = "ubuntu" ]; then
        echo 检测到系统为 Ubuntu，继续执行脚本...
        @echo off
        echo 欢迎使用幻境界一键安装脚本for Ubuntu by @Windows-PE
        echo 三秒后开始安装
        sleep 3
        echo 正在更新软件源
        apt update -y
        echo 正在安装node.js和npm
        apt install nodejs npm -y
        echo 正在安装git
        apt install git -y
        echo 正在安装PostgreSQL
        apt install postgresql postgresql-contrib -y
        echo 正在配置数据库
        sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'mc114514';"
        sudo -u postgres psql -c "CREATE DATABASE worldview_platform;"
        sudo sed -i "s/^\(local\s\+all\s\+postgres\s\+\)peer/\1md5/" $(sudo find /etc/postgresql -name pg_hba.conf | head -n1)
        echo 正在配置防火墙，阻止外部访问数据库
        ufw enable
        ufw deny 5432/tcp -y
        ufw allow from 127.0.0.1 to any port 5432
        echo 正在克隆仓库
        cd ~
        git clone https://github.com/Windows-PE2024/worldview-platform-v2
        echo 正在安装依赖
        chmod -R +x worldview-platform-v2
        cd worldview-platform-v2
        npm run install-all
        echo 启动项目
        npm run dev
        echo 项目已启动，你可以访问3000端口访问项目
    else
        echo 当前系统不是 Ubuntu，而是：$NAME
        echo 脚本已退出。
        exit 1
    fi
else
    echo 无法检测系统类型
    echo 脚本已退出。
    exit 1
fi
