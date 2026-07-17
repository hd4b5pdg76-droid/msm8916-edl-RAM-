# msm8916-edl-RAM-
通过firehose往你的msm8916设备RAM上载入lk2nd
需要准备以下文件
适用于自己设备的lk2nd
适用于自己设备的boot.img
firehose需要自己寻找

目前只有widows版本
将你的lk2nd命名lk2nd.img放到根目录下
将你的firehose命名firehose.mbn放到根目录下
boot.img同理 
运行instell.bat以管理员身份运行 
系统会验证你的安全启动状态 并尝试加载firehose
一旦成功将会往内存中发送lk2nd 这一步成功会提供一个fastboot环境 脚本会尝试发送boot.img

EMMC损坏的设备可以使用这个方案
