//
//  Version.swift
//  Twister
//
//  Created by Isaac Eaton on 5/13/20.
//  Copyright © 2020 Isaac Eaton. All rights reserved.
//

import Foundation

class Version: NSObject, NSCoding, Comparable {
    
    var major: Int
    var minor: Int
    var patch: Int
       
    override var description: String {
        return "\(major).\(minor).\(patch)"
    }
    
    init(major: Int, minor: Int, patch: Int) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
    
    convenience init(dotSeparated: String) {
        let vlist = dotSeparated.components(separatedBy: ".")
        let maj = Int(vlist[0])!
        let min = Int(vlist[1])!
        let pat = Int(vlist[2])!
        self.init(major: maj, minor: min, patch: pat)
    }
    
    required convenience init?(coder: NSCoder) {
        let maj = coder.decodeInteger(forKey: "major")
        let min = coder.decodeInteger(forKey: "minor")
        let pat = coder.decodeInteger(forKey: "patch")
        self.init(major: maj, minor: min, patch: pat)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(major, forKey: "major")
        coder.encode(minor, forKey: "minor")
        coder.encode(patch, forKey: "patch")
    }
    
    static func ==(lhs: Version, rhs: Version) -> Bool {
        return lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch
    }
    
    static func < (lhs: Version, rhs: Version) -> Bool {
        if (lhs.major == rhs.major) {
            if (lhs.minor == rhs.minor) {
                return lhs.patch < rhs.patch
            }
            return lhs.minor < lhs.minor
        }
        return lhs.major < lhs.major
    }
    
}
