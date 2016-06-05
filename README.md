# Healthkit-Demo
Using Apple's kit health framework to achieve the basic data to read, and can be written to the healthkit some data
1、全部使用oc编写的healkit代码；
2、解决healthkit内block函数存值问题，使用代理方法存值；
3、healthkit在请求授权时会弹出弹框，会出现一瞬间的背景全黑，这是由于healkit弹框加载在新的window上，此时window的背景色是黑色，因此需要获取此时的
window，并且设置成透明色
