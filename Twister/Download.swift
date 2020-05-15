//
//  Download.swift
//  Twister
//
//  Created by Isaac Eaton on 5/14/20.
//  Copyright © 2020 Isaac Eaton. All rights reserved.
//

import Foundation

class Download {
    
    var url: String
    var isDownloading = false
    var progress: Float = 0
    
    var downloadTask: URLSessionDownloadTask?
    var resumeData: Data?
    
    init(url: String) {
        self.url = url
    }
}
