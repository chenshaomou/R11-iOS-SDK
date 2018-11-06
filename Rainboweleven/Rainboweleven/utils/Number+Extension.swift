//
//  Number+Extension.swift
//  Rainboweleven
//
//  Created by Zhang Zhang on 2018/11/6.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

import UIKit

// 数字处理类
private class NumberUtils {
    
    static func convertInt64ToFloat(number:Int64) -> Float {
        return NSNumber(value: number).floatValue
    }
    
}

extension Int64 {
    
    public func toFloat() -> Float {
        return NumberUtils.convertInt64ToFloat(number: self)
    }
}
