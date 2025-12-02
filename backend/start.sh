#!/bin/bash

# 后端服务启动/重启脚本
# 使用方法: ./start.sh [start|restart|stop|status]
# 默认操作: restart

set -e  # 遇到错误立即退出

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 配置
JAR_NAME="simple-website-backend-1.0.0.jar"
APP_NAME="simple-website-backend"
LOG_FILE="app.log"
PID_FILE="app.pid"
JAVA_OPTS="-Xms512m -Xmx1024m"

# 获取操作类型，默认为 restart
ACTION="${1:-restart}"

# 获取进程ID
get_pid() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p $PID > /dev/null 2>&1; then
            echo $PID
            return 0
        else
            # PID文件存在但进程不存在，删除PID文件
            rm -f "$PID_FILE"
        fi
    fi
    # 通过进程名查找
    PID=$(pgrep -f "$JAR_NAME" | head -n 1)
    if [ -n "$PID" ]; then
        echo $PID
        return 0
    fi
    return 1
}

# 启动服务
start() {
    echo -e "${GREEN}启动服务...${NC}"
    
    # 检查JAR文件是否存在
    if [ ! -f "$JAR_NAME" ]; then
        echo -e "${RED}错误: JAR文件 $JAR_NAME 不存在${NC}"
        exit 1
    fi
    
    # 检查服务是否已经在运行
    if get_pid > /dev/null 2>&1; then
        PID=$(get_pid)
        echo -e "${YELLOW}服务已经在运行中 (PID: $PID)${NC}"
        return 0
    fi
    
    # 启动服务
    echo -e "${YELLOW}正在启动 $APP_NAME...${NC}"
    nohup java $JAVA_OPTS -jar "$JAR_NAME" > "$LOG_FILE" 2>&1 &
    NEW_PID=$!
    
    # 保存PID
    echo $NEW_PID > "$PID_FILE"
    
    # 等待服务启动
    sleep 3
    
    # 检查服务是否启动成功
    if ps -p $NEW_PID > /dev/null 2>&1; then
        echo -e "${GREEN}✓ 服务启动成功！ (PID: $NEW_PID)${NC}"
        echo -e "${YELLOW}日志文件: $LOG_FILE${NC}"
        echo -e "${YELLOW}查看日志: tail -f $LOG_FILE${NC}"
    else
        echo -e "${RED}✗ 服务启动失败，请检查日志${NC}"
        echo -e "${YELLOW}查看日志: tail -50 $LOG_FILE${NC}"
        rm -f "$PID_FILE"
        exit 1
    fi
}

# 停止服务
stop() {
    echo -e "${YELLOW}停止服务...${NC}"
    
    if get_pid > /dev/null 2>&1; then
        PID=$(get_pid)
        echo -e "${YELLOW}正在停止服务 (PID: $PID)...${NC}"
        kill $PID
        
        # 等待进程结束
        for i in {1..30}; do
            if ! ps -p $PID > /dev/null 2>&1; then
                break
            fi
            sleep 1
        done
        
        # 如果进程还在运行，强制杀死
        if ps -p $PID > /dev/null 2>&1; then
            echo -e "${YELLOW}进程未正常退出，强制终止...${NC}"
            kill -9 $PID
            sleep 1
        fi
        
        # 清理PID文件
        rm -f "$PID_FILE"
        
        echo -e "${GREEN}✓ 服务已停止${NC}"
    else
        echo -e "${YELLOW}服务未运行${NC}"
    fi
}

# 重启服务
restart() {
    echo -e "${GREEN}重启服务...${NC}"
    stop
    sleep 2
    start
}

# 查看服务状态
status() {
    echo -e "${YELLOW}检查服务状态...${NC}"
    
    if get_pid > /dev/null 2>&1; then
        PID=$(get_pid)
        echo -e "${GREEN}✓ 服务正在运行 (PID: $PID)${NC}"
        
        # 显示进程信息
        ps -p $PID -o pid,ppid,user,%cpu,%mem,etime,cmd
        
        # 显示端口占用（应用监听8084端口）
        if command -v netstat > /dev/null 2>&1; then
            echo -e "\n${YELLOW}端口占用情况:${NC}"
            netstat -tlnp 2>/dev/null | grep $PID || echo "未找到端口信息"
            netstat -tlnp 2>/dev/null | grep 8084 || echo "端口8084未监听"
        elif command -v ss > /dev/null 2>&1; then
            echo -e "\n${YELLOW}端口占用情况:${NC}"
            ss -tlnp 2>/dev/null | grep $PID || echo "未找到端口信息"
            ss -tlnp 2>/dev/null | grep 8084 || echo "端口8084未监听"
        fi
        
        # 显示最近的日志
        if [ -f "$LOG_FILE" ]; then
            echo -e "\n${YELLOW}最近的日志 (最后10行):${NC}"
            tail -n 10 "$LOG_FILE"
        fi
    else
        echo -e "${RED}✗ 服务未运行${NC}"
        exit 1
    fi
}

# 根据操作类型执行相应操作
case "$ACTION" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    status)
        status
        ;;
    *)
        echo -e "${RED}错误: 未知操作 '$ACTION'${NC}"
        echo -e "${YELLOW}使用方法: $0 [start|stop|restart|status]${NC}"
        exit 1
        ;;
esac

