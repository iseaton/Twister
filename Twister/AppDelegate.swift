//
//  AppDelegate.swift
//  Twister
//
//  Created by Isaac Eaton on 5/13/20.
//  Copyright © 2020 Isaac Eaton. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let jsonURL: String = "https://iseaton.github.io/issues.json"
    var json = [String: Any]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Twister")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func loadJSON() {
        do {
            let url = URL(string: jsonURL)!
            let jsonData = try Data(contentsOf: url)
            json = parseJSON(data: jsonData)
        } catch {
            print("Error loading JSON: \(error))")
        }
    }
    
    func parseJSON(data: Data) -> [String: Any] {
        var dict: Dictionary = [String: Any]()
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                
                if let title = json["magazine_title"] as? String {
                    dict["magazine_title"] = title
                }
                
                if let version = json["docs_version"] as? String {
                    dict["docs_version"] = Version(dotSeparated: version)
                }
                
                if let issues = json["issues"] as? [[String: String]] {
                    dict["issues"] = issues
                }
                
            }
        } catch {
            print("Error serializing JSON: \(error)")
        }
        return dict
    }
    
    func updateData() {
        
        //skip if json fetch from web fails
        if (json["docs_version"] as? Version) == nil {
            return
        }
        
        let serverVersion = json["docs_version"] as! Version
        let defaults = UserDefaults.standard
        
        do {
            if let local = defaults.value(forKey: "version") as? Data {
                let localVersion = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(local) as! Version
                if localVersion < serverVersion {
                    print("Version \(serverVersion) is available! Beginning update...")
                    mergeIssues()
                    let data = try NSKeyedArchiver.archivedData(withRootObject: serverVersion, requiringSecureCoding: false)
                    defaults.setValue(data, forKey: "version")
                    print("Update complete!")
                } else {
                    print("Database is up to date.")
                }
            } else {
                let data = try NSKeyedArchiver.archivedData(withRootObject: serverVersion, requiringSecureCoding: false)
                defaults.setValue(data, forKey: "version")
                print("First run! Current version is: \(serverVersion)")
                restoreAllIssuesFromServer()
            }
        } catch {
            print("Versioning failed: \(error)")
        }
    }
    
    func mergeIssues() {
        print("Updated!")
    }
    
    func addIssue(issueData: [String: String]) {
        let context = self.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Issue", in: context)!
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM"
        
        let imageURL = URL(string: issueData["coverUrl"]!)!
        let imageData = try! Data(contentsOf: imageURL)
        //replace above with default image if none is found?
        
        let entry = Issue(entity: entity, insertInto: context)
        
        entry.uniqueID = Int16(issueData["uniqueID"]!)!
        entry.version = Version(dotSeparated: issueData["version"]!)
        entry.title = issueData["title"]!
        entry.date = format.date(from: issueData["date"]!)!
        entry.cover = UIImage(data: imageData)!
        entry.fileType = issueData["type"]!
        entry.webLocation = URL(string: issueData["contentUrl"]!)!
        
        do {
            try context.save()
        } catch {
            print("Could not save the issue: \(error)")
        }
    }
    
    func restoreAllIssuesFromServer() {
        
        wipeLocalData()
        
        for issue in (json["issues"] as! [[String: String]]) {
            addIssue(issueData: issue)
        }
        
    }
    
    func wipeLocalData() {
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<Issue>(entityName: "Issue")
        do {
            let results = try context.fetch(request)
            for item in results {
                context.delete(item)
            }
        } catch {
           print("Search for local issues failed: \(error)")
        }
    }
    
}

