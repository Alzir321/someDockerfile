#!/bin/sh
set -e

mergedListFile="/AutoSignMachine/merged_list_file.sh"
echo "定时任务文件路径为 ${mergedListFile}"
echo -e '' >  ${mergedListFile}

if [ $ENABLE_52POJIE ]; then
    echo "10 13 * * * node /AutoSignMachine/index.js 52pojie --htVD_2132_auth=${htVD_2132_auth} --htVD_2132_saltkey=${htVD_2132_saltkey} >> /AutoSignMachine/logs/52pojie.log 2>&1 &" >>${mergedListFile}
else
    echo "未配置启用52pojie签到任务环境变量ENABLE_52POJIE，故不添加52pojie定时任务..."
fi

if [ $ENABLE_BILIBILI ]; then
    echo "*/30 7-22 * * * node /AutoSignMachine/index.js bilibili --username ${BILIBILI_ACCOUNT} --password ${BILIBILI_PWD} >> /AutoSignMachine/logs/bilibili.log 2>&1 &" >>${mergedListFile}
else
    echo "未配置启用bilibi签到任务环境变量ENABLE_BILIBILI，故不添加Bilibili定时任务..."
fi

if [ $ENABLE_IQIYI ]; then
    echo "*/30 7-22 * * * node /AutoSignMachine/index.js iqiyi --P00001 ${P00001} --P00PRU ${P00PRU} --QC005 ${QC005}  --dfp ${dfp} >> /AutoSignMachine/logs/iqiyi.log 2>&1 &" >>${mergedListFile}
else
    echo "未配置启用iqiyi签到任务环境变量ENABLE_IQIYI，故不添加iqiyi定时任务..."
fi

if [ $ENABLE_UNICOM ]; then
    echo "*/30 7-22 * * * node /AutoSignMachine/index.js unicom --user ${UNICOM_PHONE} --password ${UNICOM_PWD} --appid ${UNICOM_APPID} >> /AutoSignMachine/logs/unicom.log 2>&1 &" >>${mergedListFile}
else
    echo "未配置启用unicom签到任务环境变量ENABLE_UNICOM，故不添加unicom定时任务..."
fi

echo "增加默认脚本更新任务..."
echo "21 */1 * * * docker_entrypoint.sh >> /AutoSignMachine/logs/default_task.log 2>&1" >>$mergedListFile

echo "判断是否配置自定义shell执行脚本..."
if [ 0"$CUSTOM_SHELL_FILE" = "0" ]; then
    echo "未配置自定shell脚本文件，跳过执行。"
else
    if expr "$CUSTOM_SHELL_FILE" : 'http.*' &>/dev/null; then
        echo "自定义shell脚本为远程脚本，开始下在自定义远程脚本。"
        wget -O /jds/shell_script_mod.sh $CUSTOM_SHELL_FILE
        echo "下载完成，开始执行..."
        echo "#远程自定义shell脚本追加定时任务" >>$mergedListFile
        sh /jds/shell_script_mod.sh
        echo "自定义远程shell脚本下载并执行结束。"
    else
        if [ ! -f $CUSTOM_SHELL_FILE ]; then
            echo "自定义shell脚本为docker挂载脚本文件，但是指定挂载文件不存在，跳过执行。"
        else
            echo "docker挂载的自定shell脚本，开始执行..."
            echo "#docker挂载自定义shell脚本追加定时任务" >>$mergedListFile
            sh $CUSTOM_SHELL_FILE
            echo "docker挂载的自定shell脚本，执行结束。"
        fi
    fi
fi

echo "判断是否配置了随即延迟参数..."
if [ $RANDOM_DELAY_MAX ]; then
    if [ $RANDOM_DELAY_MAX -ge 1 ]; then
        echo "已设置随机延迟为 $RANDOM_DELAY_MAX , 设置延迟任务中..."
        sed -i "/node/sleep \$((RANDOM % \$RANDOM_DELAY_MAX)) && node/g" $mergedListFile
    fi
else
    echo "未配置随即延迟对应的环境变量，故不设置延迟任务..."
fi

echo "增加 |ts 任务日志输出时间戳..."
sed -i "/\( ts\| |ts\|| ts\)/!s/>>/\|ts >>/g" $mergedListFile

echo "加载最新的定时任务文件..."
crontab $mergedListFile
