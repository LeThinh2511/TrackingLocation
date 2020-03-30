//
//  Logger.swift
//  TrackingLocation
//
//  Created by ThinhLe on 3/30/20.
//  Copyright © 2020 ThinhLe. All rights reserved.
//

import Foundation

class Logger {
    static let locationLog = "locationLog"
    static let locationDir = "location"
    class func write(text: String, to fileNamed: String, folder: String = locationDir) {
        let textToBeAppended = "\(Date()) " + text + "\n"
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else { return }
        print(writePath.absoluteString)
        let file = writePath.appendingPathComponent(fileNamed + ".txt")
        
        if let fileHandle = FileHandle(forWritingAtPath: file.path) {
            fileHandle.seekToEndOfFile()
            fileHandle.write(textToBeAppended.data(using: .utf8)!)
        } else {
            print("File doesn't exists")
            try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
            try? textToBeAppended.write(to: file, atomically: false, encoding: String.Encoding.utf8)
        }
    }
}
