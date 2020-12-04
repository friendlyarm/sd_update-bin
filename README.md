## sd_update-bin
sd_update是一个命令行工具，可将系统映象文件烧写到分区的指定位置。  
  
## 如何安装
在开发板上运行如下命令:
```
git clone https://github.com/friendlyarm/sd_update-bin --depth 1 -b main
cd sd_update-bin
chmod 755 install.sh
./install.sh
```

## 如何使用
先准备好如下文件，放在同一个目录：
1) partmap.txt文件  (rockchip平台是 parameter.txt) ，sd_update需要通过它们来获得分区的布局信息，这个文件可以从网盘的images-for-eflasher目录通过解压OS对应的压缩包来获得;
2) 要烧写的文件，例如rockchip内核对应的 kernel.img和resource.img;
  
sd_update 主要参数：
1) 用 -d 参数 指定目标存储介质 (TF卡或eMMC)  
2) 用 -p 参数指定 partmap.txt 文件(rockchip平台是 parameter.txt)   
  
示例如下，其中，CURR_BLKDEV变量存放当前系统所处的存储设备：
```
CURR_BLKDEV=`cat /proc/cmdline | sed -e 's/^.*root=//' -e 's/ .*$//' | awk -F'p' '{print $1}'`
sd_update -d $CURR_BLKDEV -p parameter.txt
```

## 使用示例1：更新rk3399的内核
将编译生成的kernel.img，resource.img和parameter.txt放在同一个目录，执行以下命令：
```
# sd_update -d /dev/mmcblk1 -p parameter.txt
----------------------------------------------------------------
[/dev/mmcblk1] capacity = 30436MB, 31914983424 bytes
current /dev/mmcblk1 partition:
MBR.0 start : 0x0000000200 size 0x076e47fe00  kB
----------------------------------------------------------------
parsing parameter.txt:
create new GPT 9:
----------------------------------------------------------------
copy from: . to /dev/mmcblk1
fail open ./idbloader.img, ret = No such file or directory, continue ...
 [RAW. 5]:     3664 KB | ./resource.img   > 100% : done.
 [RAW. 6]:    30722 KB | ./kernel.img     > 100% : done.
----------------------------------------------------------------
```
## 使用示例2：更新rk3399的整个系统
将网盘上下载的固件压缩包用 scp 下载到开发板上，并解压：
```
scp root@YOUR-HOSTPC-IP:/path/to/RK3399/images-for-eflasher/lubuntu-desktop-images.tgz .
tar xzf lubuntu-desktop-images.tgz
```
开始烧写系统：
```
cd lubuntu
CURR_BLKDEV=`cat /proc/cmdline | sed -e 's/^.*root=//' -e 's/ .*$//' | awk -F'p' '{print $1}'`
echo 1 > /proc/sys/kernel/sysrq
echo u > /proc/sysrq-trigger || umount /
sd_update -d $CURR_BLKDEV -p parameter.txt
echo b > /proc/sysrq-trigger
```
