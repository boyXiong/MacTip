//
//  NSColor+Extension.swift
//  ConfigMap
//
//  Created by key on 2020/5/19.
//  Copyright © 2020 key. All rights reserved.
//

import Foundation
import AppKit

extension NSColor {
    
    public static func hex(_ hex:String) -> NSColor? {
        
        var result : NSColor? = nil
//        var colorCode : UInt32 = 0
//        var redByte, greenByte, blueByte : UInt8
//
//        // these two lines are for web color strings that start with a #
//        // -- as in #ABCDEF; remove if you don't have # in the string
//        let substring1 = hex.substringFromIndex(index1)
//
//        let scanner = Scanner(string: substring1)
//        let success = scanner.scanHexInt(&colorCode)
//
//        if success == true {
//            redByte = UInt8.init(truncatingBitPattern: (colorCode >> 16))
//            greenByte = UInt8.init(truncatingBitPattern: (colorCode >> 8))
//            blueByte = UInt8.init(truncatingBitPattern: colorCode) // masks off high bits
//
//            result = NSColor(calibratedRed: CGFloat(redByte) / 0xff, green: CGFloat(greenByte) / 0xff, blue: CGFloat(blueByte) / 0xff, alpha: 1.0)
//        }
        return result
    }
    
    var hexString: String {
        let red = Int(round(self.redComponent * 0xFF))
        let green = Int(round(self.greenComponent * 0xFF))
        let blue = Int(round(self.blueComponent * 0xFF))
        let hexString = NSString(format: "#%02X%02X%02X", red, green, blue)
        return hexString as String
    }
    
    
    
}
