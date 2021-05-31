### 使用说明须知
- 该版本bot功能虽然提供了cookie扫码自动写入生效并测试的功能，但是代码 __`不开源`__、__`不开源`__、__`不开源`__， __请慎重__、 __请慎重__、 __请慎重__(不排除被我钓鱼的可能呢🎣)，而且有判断如果是奸商牟利的并无法使用该功能
```shell
#bot 目前功能
/spnode 选择执行JS脚本文件 
/logs 选择下载日志文件 
/glc 扫码获取Cookie 
/cmd 执行任何想要执行的命令 例：/cmd ls -l 
/ak 添加/更新快捷回复键盘 例：/ak 键盘显示===/cmd echo 'show reply keyboard' 
/dk 删除快捷回复键盘 例：/dk 键盘显示 
/dl 通过链接下载文件 例：/dl https://raw.githubusercontent.com/iouAkira/someDockerfile/master/dd_scripts/shell_mod_script.sh
```
- 配置参考
![image](https://user-images.githubusercontent.com/6993269/119672910-8b236f00-be6d-11eb-8786-f58eff84c039.png)
```sh
dd
├── data
│   ├── logs
│   │   └── xxxxx.log
│   ├── env.sh
│   ├── cookies.list
│   ├── genCodeConf.list
│   ├── my_crontab_list.sh
│   └── replyKeyboard.list
└── docker-compose.yml
```
- docker-compose.yml
```yml
dd_scripts:
  image: akyakya/jd_scripts
  container_name: dd
  restart: always
  volumes:
    - ./data:/data
  tty: true
  extra_hosts:
    - "mainhost:172.17.0.1"
  environment:
    - TG_BOT_TOKEN=14*******************Q2Y
    - TG_USER_ID=1*********6
    #随机延迟配置该配置在spnode之外,如果要使用不能配置在env.sh,需要配置在docker-compose里面
    - RANDOM_DELAY_MAX=20
```
