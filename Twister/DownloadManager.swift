//
//  DownloadManager.swift
//  Twister
//
//  Created by Isaac Eaton on 5/14/20.
//  Copyright © 2020 Isaac Eaton. All rights reserved.
//

import Foundation

class DownloadManager: NSObject, URLSessionDownloadDelegate, ObservableObject {
    
    var activeDownloads: [URL: Download] = [:]
    
    lazy var downloadSession: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    func startDownload(issue: Issue) {
        let download = Download(issue: issue)
        let url = issue.webLocation
        download.task = downloadSession.downloadTask(with: url)
        download.task?.resume()
        //download.isDownloading = true
        activeDownloads[url] = download
    }
    
    func pauseDownload(issue: Issue) {
        let url = issue.webLocation
        guard let download = activeDownloads[url] else {
            return
        }
        
        download.task?.cancel(byProducingResumeData: { data in
            download.resumeData = data
        })
        //download.isDownloading = false
    }
    
    func resumeDownload(issue: Issue) {
        let url = issue.webLocation
        guard let download = activeDownloads[url] else {
            return
        }
        
        if let resumeData = download.resumeData {
            download.task = downloadSession.downloadTask(withResumeData: resumeData)
        } else {
            download.task = downloadSession.downloadTask(with: url)
        }
        
        download.task?.resume()
        //download.isDownloading = true
    }
    
    func cancelDownload(issue: Issue) {
        let url = issue.webLocation
        guard let download = activeDownloads[url] else {
            return
        }
        
        download.task?.cancel()
        activeDownloads[url] = nil
        //download.isDownloading = false
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let sourceURL = downloadTask.originalRequest?.url else {
            return
        }
        
        let download = activeDownloads[sourceURL]
        activeDownloads[sourceURL] = nil
        
        let fileManager = FileManager.default
        let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentPath.appendingPathComponent(sourceURL.lastPathComponent)
        print("Saving file at: \(destinationURL)")
        
        try? fileManager.removeItem(at: destinationURL)
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
            download?.issue.fileLocation = destinationURL
        } catch {
            print("Error saving file: \(error)")
        }
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard
            let url = downloadTask.originalRequest?.url,
            let download = activeDownloads[url]
            else {
                return
        }
        download.progress = (Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
    }
    
}
