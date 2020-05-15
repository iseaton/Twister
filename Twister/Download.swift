//
//  Download.swift
//  Twister
//
//  Created by Isaac Eaton on 5/14/20.
//  Copyright © 2020 Isaac Eaton. All rights reserved.
//

import SwiftUI

class Download {
    
    var issue: Issue
    var url: URL
    
    var progress: Float = 0.0
    
    var task: URLSessionDownloadTask?
    var resumeData: Data?
    
    init(issue: Issue) {
        self.issue = issue
        self.url = issue.webLocation
    }
    
}
