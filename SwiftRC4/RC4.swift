//
//  RC4.swift
//  SwiftRC4
//
//  Created by Willy Liu on 2015/1/14.
//  Copyright (c) 2015年 Willy Liu. All rights reserved.
//

import Foundation

public class RC4 {
    internal var box = [UInt8](count: 256, repeatedValue: 0)
    internal var x = 0
    internal var y = 0
    public class func crypt(data: NSData, key: String) -> NSData {
        let cryptor = RC4(key: key)
        return cryptor.crypt(data)
    }

    public init(key:String) {
        // initializes box, x and y. remember to reset x and y after intializing box
        let keyData = key.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        assert(keyData.length == key.lengthOfBytesUsingEncoding(NSUTF8StringEncoding), "Length of key data must match length of key")
        let keyByteArray = UnsafePointer<UInt8>(keyData.bytes)

        for i in 0 ..< 256 {
            box[i] = UInt8(i)
        }
        for i in 0 ..< 256 {
            let keyIndex = i % keyData.length
            let keyChar = keyByteArray[keyIndex]
            x = (x + Int(box[i]) + Int(keyChar)) % 256
            (box[i], box[x]) = (box[x], box[i])
        }
        x = 0
        y = 0
    }

    public func crypt(data: NSData) -> NSData {
        let outData = NSMutableData(length: data.length)!
        let out = UnsafeMutablePointer<UInt8>(outData.bytes)
        let dataByteArray = UnsafePointer<UInt8>(data.bytes)
        for i in Range<Int>(0 ..< data.length) {
            x = (x + 1) % 256
            y = (y + Int(box[x])) % 256
            (box[x], box[y]) = (box[y], box[x])
            let char = dataByteArray[i]
            out[i] = char ^ box[(Int(box[x]) + Int(box[y])) % 256]
        }
        return outData
    }
}