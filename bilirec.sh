#!/bin/bash

echo "Simple&Naive Bilibili Live Recorder"
echo -e "\e[1m\e[95mRunning! Watching: \e[33m${NAME} \e[0m- \e[1m\e[95m${BILI_ROOM_ID}\e[0m"
while true
do
    srcInfo=$(curl -s https://api.live.bilibili.com/room/v1/Room/get_info?id="${BILI_ROOM_ID}" | jq '{title: .data.title, onair: .data.live_status}')
    title=$(echo "${srcInfo}" | jq .title)
    onair=$(echo "${srcInfo}" | jq .onair)
    timestamp=$(date +'%Y-%m-%d_%H:%M_%Z')
    printf "\r \e[1m\e[36mWaiting On Air... TIME: ${timestamp}\e[0m"
    if [[ $onair = "1" ]]; then
        echo -e "\e[1m\e[92m LIVE NOW! Start Recording! \e[0m[${timestamp}]"
        yt-dlp --wait-for-video 60 --format=best[vcodec!=hevc] https://live.bilibili.com/"${BILI_ROOM_ID}" -o "【${NAME}】${timestamp} 录播.mp4"
        if [[ $? == "0" ]]; then
            echo -e "\e[1m\e[96m Record End. Wait for the next one.\e[0m"
            continue
        fi
    fi
    sleep 1m
done
