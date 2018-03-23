# R11-iOS-SDK

## 项目支持Carthage引入
```SHELL
github "chenshaomou/R11-iOS-SDK" "master"
```

## Carthage安装
```SHELL
$ brew update
$ brew install carthage
```
# Native API
### 获取jsbridge对象
+ 获取SDK对象（单例），这个时候进行初始化事件和插件：jsbridge=getInstance/share
+ 初始化sdk插件，不要让用户显式调用：jsbridge.initPlugins()
+ 初始化sdk事件，不要让用户显式调用：jsbridge.initEvents()

## 读取页面
+ 读取本地页面：jsbridge.loadLocalURL(String url,String hash)
+ 读取远程页面：jsbridge.loadRemoteURL(String url,String hash)

## 注册插件
+ 注册插件：jsbridge.register(module:String,method:String,action:(object)->String)

## 调用js插件
- 异步调用js插件：jsbridge.call(module:String,method:String,params:kvmap,callback:function(kvobject)
- 原生调js暂时不做同步

## event bus事件总线
- 事件监听器，事件总线通过事件插件实现：jsbridge.register(module:’event',method:’on',action:(object)->String)
- 监听事件：jsbridge.on(eventName:String,function(jsobject))
- 解除监听：jsbridge.off(eventName:String)
- 发送事件：jsbridge.send(eventName:String,jsobject)

***

# JavaScript API
## 当用SDK的webview打开的时候，SDK的webview将会给window自动绑定一个jsbridge的对象
+ 注册插件可以让原生调用：jsbridge.register(module:String,method:String,callfn:function(jsobject))
+ 同步调用原生的插件：jsbridge.call(module:String,method:String,params:jsobject)
+ 异步调用原生的插件：jsbridge.call(module:String,method:String,params:jsobject,callback:function(jsobject))
+ 异步调用原生的插件（基于promise）：jsbridge.promise(module:String,method:String,params:jsobject)

## 非自定义的插件（我们提供的插件）有直接生成的对象可以调用，如存储组件
- 同步调用存储的插件：jsbridge.call(‘store’,’set’,jsobject)
- 同步调用存储的插件：jsbridge.store.set(jsobject,ture)
- 异步调用存储的插件，返回一个promise：jsbridge.store.set(jsobject) 或 jsbridge.store.set(jsobject,false)
- 异步调用存储的插件：jsbridge.call(store’,’set’,object,function(jsobject))

## event bus事件总线
- 事件监听器，事件总线通过事件插件实现：jsbridge.register(module:’event',method:’on',function(jsobject)->String)
- 监听事件：jsbridge.on(eventName:String,function(jsobject))
- 解除监听：jsbridge.off(eventName:String)
- 发送事件：jsbridge.send(eventName:String,jsobject)


