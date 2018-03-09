//
//  registerNative.js
//  Rainboweleven
//
//  Created by shaomou chen on 09/03/2018.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

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
 */
window.jsBridge[module] = window.jsBridge[module] || {};
Object.assign(window.jsBridge[module], {method:
    function (params, callback) {
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
})
