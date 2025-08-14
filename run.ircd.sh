#!/usr/bin/env bash

# Цвета для вывода
RED='\033[0;31m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

# Определяем порт
if [ -z "$1" ]; then
    PORT=6667
else
    PORT="$1"
fi

# Определяем пароль
if [ -z "$2" ]; then
    PASSFILE="./pass/pass.txt"
    if [ ! -s "$PASSFILE" ]; then
        echo -e "${RED}Ошибка: Файл $PASSFILE отсутствует или пустой.${NC}"
        exit 1
    fi
    PASSWORD=$(cat "$PASSFILE")
else
    PASSWORD="$2"
fi

# Вывод информации о порте
echo -e "Сервер будет слушать порт: ${BLUE}${PORT}${NC}"

# Вывод информации о источнике пароля (если нужен)
if [ -z "$2" ]; then
    echo -e "Пароль взят из файла:     ${GREEN}${PASSFILE}${NC}"
else
    echo -e "Пароль передан вручную:   ${GREEN}<скрыт>${NC}"
fi

# Запуск сервера
exec ./ircserv "$PORT" "$PASSWORD"
