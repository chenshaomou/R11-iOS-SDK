/**
 * 初始化jsBridge对象
 *
 * @author andy(Andy)
 * @datetime 2017-12-20 16:09 GMT+8
 * @email 411086563@qq.com
 * @returns {{call: call, on: on, off: off, send: send, register: register}}
 */
function initJsBridge(webViewType) {
    /**
     * window下定义jsBridge
     * @type {{}}
     */
    window.jsBridge = window.jsBridge || {}
    /**
     * jsBridge下定义callbacks，异步调用插件时的回调function集合
     * @type {Array}
     */
    window.jsBridge.callbacks = window.jsBridge.callbacks || []
    /**
     * jsBridge下定义callbackCount，异步调用插件时的回调function命名计算标识
     * @type {number}
     */
    window.jsBridge.callbackCount = window.jsBridge.callbackCount || 0
    /**
     * jsBridge下定义原生WebView类型信息，由原生WebView初始化的时候写入到jsBridge.webViewType中，取值：
     * UIWV：ios UIWebView（ios 8.0以下）
     * WKWV：ios WKWebView（ios 8.0及以上）
     * ADWKWV：android WebKit WebView（android 4.4以下）
     * ADCRMWV：android chromium WebView（android 4.4及以上）
     * @type {string}
     */
    window.jsBridge.webViewType = window.jsBridge.webViewType || webViewType
    /**
     * 注册JS插件/方法到window.jsBridge，使原生能通过window.jsBridge调用，使用示例：
     * // 带module注册
     * jsBridge.register('store', 'getValue', function(params){
     *      var key = params['key']
     *      return window.localStorage.getItem(key)
     *   }
     * )
     * // 不带module注册
     * jsBridge.register('paySuccess', function(params){
     *      var orderNo = params['orderNo']
     *      notifyPaySuccess(orderNo)
     *      return true
     *    }
     * )
     * @type {Function}
     * @param module 模块名，可为空，不传默认为userDefault
     * @param method 方法名，非空
     * @param callFun 方法体，非空
     */
    window.jsBridge.register = window.jsBridge.register || function (module, method, callFun) {
        // 参数为2个
        if (arguments.length == 2) {
            callFun = method
            method = module
            // 没有传递模块名，模块名默认为userDefault
            module = 'userDefault'
        }
        // 参数为3个
        else if (arguments.length == 3) {
            //支持
        }
        // 参数为1个或者其它，不支持，抛出异常
        else {
            throw 'register方法必须是2个或者3个参数'
        }
        var action = {}
        action[method] = callFun
        window.jsBridge[module] = window.jsBridge[module] || {}
        Object.assign(window.jsBridge[module], action)
        // window.jsBridge[module] = action
    }
    /**
     * 注册原生插件/方法到window.jsBridge，使JS能通过window.jsBridge调用，原生使用示例：
     * // 原生带module注册
     * jsBridge.registerNative('store', 'getValue')
     * // 不带module注册
     * jsBridge.register('paySuccess')
     * // 原生自定义JS function
     * jsBridge.registerNative('store', 'getValue', function (key,value){var params={\"key\":key,\"value\":value};return window.jsBridge.call(module,method,params)})
     * @type {Function}
     * @param module 模块名，可为空，不传默认为userDefault
     * @param method 方法名，非空
     * @param customFun 自定义JS方法，可空，适用于对参数做特殊定制的情况，如参数为key和value模式，由原生自行组装js function方法体
     */
    window.jsBridge.registerNative = window.jsBridge.registerNative || function (module, method, customFun) {
        var lastArg = arguments[arguments.length - 1]
        // 是否含有自定义JS方法
        var hasCustomFun = typeof lastArg == 'function'
        // 参数为1个
        if (arguments.length == 1) {
            if (hasCustomFun) {
                throw 'registerNative不支持1个为function的参数'
            } else {
                method = module
                // 没有传递模块名，模块名默认为userDefault
                module = 'userDefault'
            }
        }
        // 参数为2个
        else if (arguments.length == 2) {
            if (hasCustomFun) {
                customFun = method
                method = module
                // 没有传递模块名，模块名默认为userDefault
                module = 'userDefault'
            } else {
                // 支持
            }
        }
        // 参数为3个
        else if (arguments.length == 3) {
            // 支持
        }
        // 参数为0个或者其它，不支持，抛出异常
        else {
            throw 'registerNative方法必须是1~3个参数'
        }
        var action = {}
        // 自定义JS方法
        if (hasCustomFun) {
            action[method] = customFun
        }
        // 未自定义JS方法
        else {
            action[method] = function (params, callback) {
                // 参数为0个
                if (arguments.length === 0) {
                    return window.jsBridge.call(module, method, {})
                }
                // 参数为1个
                if (arguments.length === 1) {
                    return window.jsBridge.call(module, method, params)
                }
                // 参数为2个，含有异步回调
                if (arguments.length === 2) {
                    window.jsBridge.call(module, method, params, callback)
                }
            }
        }
        window.jsBridge[module] = window.jsBridge[module] || {}
        Object.assign(window.jsBridge[module], action)
        // window.jsBridge[module] = action
    }
    /**
     * 调用原生的核心方法，调用原生插件的同步/异步方法，使用示例：
     * // 带module同步调用
     * var value = jsBridge.call('store', 'getValue', 'token')
     * // 带module异步调用
     * jsBridge.call('store', 'getValue', 'token', function(value){
     *      console.log('value:' + value)
     *   }
     * )
     * // 不带module同步调用
     * var payResult = jsBridge.call('requestToPay', {'orderNo': '20171223'})
     * // 不带module异步调用
     * jsBridge.call('requestToPay', {'orderNo': '20171223'}, function(payResult){
     *      console.log('payResult:' + payResult)
     *   }
     * )
     * @type {Function}
     * @param module 模块名，可为空，不传默认为userDefault
     * @param method 方法名，非空
     * @param params 参数，非空
     * @param callback 异步调用时完成的回调function，同步时可为空
     * @returns 同步时返回string，异步返回void由callback携带string数据返回
     */
    window.jsBridge.call = window.jsBridge.call || function (module, method, params, callback) {
        var lastArg = arguments[arguments.length - 1]
        // 是否异步
        var async = typeof lastArg == 'function'
        // 参数为3个
        if (arguments.length == 3) {
            // 异步
            if (async) {
                callback = params
                params = method
                method = module
                // 没有传递模块名，模块名默认为userDefault
                module = 'userDefault'
            }
            // 同步
            else {
                // 参数齐全
            }
        }
        // 参数为4个
        else if (arguments.length == 4) {
            // 参数齐全
        }
        // 参数个数为其它，不支持，抛出异常
        else {
            throw 'register方法必须是3个或者4个参数'
        }
        if (typeof params != 'string') {
            // Object或者Array，转成字符串
            if (typeof params == 'object' || Object.prototype.toString.call(params) == '[object Array]') {
                params = JSON.stringify(params || {})
            } else {
                // 转成字符串
                params = params.toString()
            }
        }
        // 请求原生的数据
        var request
        // 异步
        if (async) {
            // 回调的function名字，默认挂在window.jsBridge.callbacks下面，同时会传递给原生作为原生回调的callback引用名字，例如store_getValue_10
            var callbackName = module + '_' + method + '_' + window.jsBridge.callbackCount++
            // 将callbackName挂到window.jsBridge.callbacks下面
            window.jsBridge.callbacks[callbackName] = callback
            // 请求原生的所有数据
            request = {
                'module': module,
                'method': method,
                'params': params,
                'callbackName': callbackName
            }
        }
        // 同步
        else {
            // 请求原生的所有数据
            request = {
                'module': module,
                'method': method,
                'params': params
            }
        }
        // 将请求数据转成字符串
        var requestStr = JSON.stringify(request || {})
        // ios WKWebView，执行window.prompt进行插件调用
        if (window.jsBridge.webViewType == 'WKWV') {
            // 异步
            if (async) {
                window.prompt('', requestStr)
            }
            // 同步
            else {
                return window.prompt('', requestStr);
            }
        }
        // 其他WebView
        else {
            // window.nativeBridge是由原生WebView API注册生成，各个平台具体实现可能不一样，android一般是个object，ios一般是个function
            // 如果window.nativeBridge是一个function，那么执行nativeBridge方法进行插件调用，如ios UIWebView
            if (typeof window.nativeBridge == 'function') {
                // 异步
                if (async) {
                    window.nativeBridge(requestStr)
                }
                // 同步
                else {
                    return window.nativeBridge(requestStr)
                }
            }
            // 如果nativeBridge是一个object，那么执行nativeBridge的call方法进行插件调用，如android WebView
            else if (typeof window.nativeBridge == 'object') {
                // 异步
                if (async) {
                    window.nativeBridge.call(requestStr)
                }
                // 同步
                else {
                    return window.nativeBridge.call(requestStr)
                }
            }
            // 没有定义nativeBridge对象或者nativeBridge为其他类型，暂时不支持
            else {
                // 没有可以调用的原生bridge对象，FIXME H5可以考虑自己吞了通用异常逻辑
                console.log('无window.nativeBridge被注册')
            }
        }
    }
    /**
     * 异步调用原生的插件（基于promise）
     * @type {Function}
     * @param module 模块名，可为空，不传默认为userDefault
     * @param method 方法名，非空
     * @param params 参数，非空
     * @returns {Promise}
     */
    window.jsBridge.promise = window.jsBridge.promise || function (module, method, params) {
        return new Promise(function (resolve, reject) {
            try {
                window.jsBridge.call(module, method, params, function (result) {
                    /**
                     var jsResult = JSON.parse(result)
                     if (!jsResult.isError) {
                         resolve(jsResult.data)
                     } else {
                         reject(jsResult.error)
                     }
                     */
                    resolve(result)
                })
            } catch (e) {
                reject(e)
            }
        })
    }
    /**
     * 监听原生事件，使用示例：
     * jsBridge.on('keyboardUp', function(keyboardHeight){
     *      console.log('keyboardHeight:' + keyboardHeight)
     *   }
     * )
     * @type {Function}
     * @param eventName 要监听的事件名，非空
     * @param callback 回调方法，非空
     */
    window.jsBridge.on = window.jsBridge.on || function (eventName, callback) {
        // 监听事件，文档规定监听原生事件的module值固定为：event
        window.jsBridge.call('event', 'on', {'eventName': eventName}, callback)
    }
    /**
     * 解除监听原生事件，使用示例：
     * jsBridge.off('keyboardUp')
     * @type {Function}
     * @param eventName 取消监听的事件名，非空
     */
    window.jsBridge.off = window.jsBridge.off || function (eventName) {
        // 解除监听，文档规定解除监听原生事件的module值固定为：event
        return window.jsBridge.call('event', 'off', {'eventName': eventName})
    }
    /**
     * 发送事件到原生，使用示例：
     * jsBridge.send('domLoadFinish', {'useTime': 100})
     * @type {Function}
     * @param eventName 要发送的事件名，非空
     * @param params 参数，非空
     */
    window.jsBridge.send = window.jsBridge.send || function (eventName, params) {
        // 发送事件，文档规定解除监听原生事件的module值固定为：event
        return window.jsBridge.call('event', 'send', {'eventName': eventName, 'params': params})
    }
    /**
     * 发送文档事件，使用示例：
     * // 1个参数
     * jsBridge.sendDocumentEvent('deviceready')
     * // 2个参数
     * jsBridge.sendDocumentEvent('deviceready', true)
     * @type {Function}
     * @param eventName 要发送的事件名，非空
     * @param cancelable 是否可取消，可为空，不传默认为false
     */
    window.jsBridge.sendDocumentEvent = window.jsBridge.sendDocumentEvent || function (eventName, cancelable) {
        // 发送文档事件给JS
        var event = window.document.createEvent('Event')
        // 参数为1个
        if (arguments.length == 1 || typeof cancelable == 'undefined') {
            // 默认为false
            cancelable = false
        }
        event.initEvent(eventName, false, cancelable)
        // 发送事件
        window.document.dispatchEvent(event)
    }
}
// 初始化
initJsBridge('ADCRMWV')