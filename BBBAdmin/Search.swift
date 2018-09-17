//
//  Search.swift
//  BBBAdmin
//
//  Created by Blind Joe Death on 10.09.2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol SearchListenerDelegate {
    func searchDone(success : Bool)
}

class Search {

    private static let url = URL(string: "http://80.211.8.79/Home/GetUserInfos?key=\(appKey)")!
    
    static var managedObjectContext : NSManagedObjectContext!
    
    private static var dataTask: URLSessionDataTask? = nil
    
    private static var delegates : [SearchListenerDelegate] = []
    
    public static func becomeDelegate(_ delegate : SearchListenerDelegate){
        delegates.append(delegate)
    }
    
    public static func performSearch() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let session = URLSession.shared
        dataTask = session.dataTask(with: url, completionHandler: {
            data, response, error in
            
            let exitClosure : (Bool) -> Void = {result in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    for delegate in delegates {
                        delegate.searchDone(success: result)
                    }
                }
            }
            
            if let error = error as? NSError, error.code == -999 {
                exitClosure(false)
                return
            }
            
            var success = false
            if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let jsonData = data,
                let parsedInfos = self.parse(json: jsonData){
                
                success = true
                self.addParsedToDataBase(parsedInfos)
            }
            
            exitClosure(success)
        })
        dataTask?.resume()
    }
    
    private static func parse(json data: Data) -> [UserInfoParsed]? {
        do {
            
            let decoder = JSONDecoder()
            return try decoder.decode([UserInfoParsed].self, from: data)
            
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
    
    private static func tryFetchEntity(userId : String) -> UserInfo? {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserInfo")
        fetchRequest.predicate = NSPredicate(format: "userId = %@",
                                             argumentArray: [userId])
        fetchRequest.includesSubentities = false
        
        var userInfo : [UserInfo]? = nil
        
        Search.managedObjectContext.performAndWait {
            do {
                userInfo = try Search.managedObjectContext.fetch(fetchRequest) as? [UserInfo]
            }
            catch {
                print("error executing fetch request: \(error)")
            }
        }
        return userInfo?.first
    }
    
     private static func addParsedToDataBase(_ parsedObjects : [UserInfoParsed]){

        for parsed in parsedObjects{
            
            var userInfo : UserInfo!
            if let info = self.tryFetchEntity(userId: parsed.userId){
                userInfo = info
            } else {
                Search.managedObjectContext.performAndWait {
                    userInfo = UserInfo(context: Search.managedObjectContext)
                    userInfo.userId = parsed.userId
                    userInfo.settings = Settings(context: Search.managedObjectContext)
                }
            }
            Search.managedObjectContext.performAndWait {
                
                userInfo.firstName = parsed.firstName
                userInfo.lastName = parsed.lastName
                userInfo.nickName = parsed.nickName
                userInfo.videoMessageCount = Int64(parsed.videoMessageCount)
                userInfo.videoCount = Int64(parsed.videoCount)
                userInfo.audioMessageCount = Int64(parsed.audioMessageCount)
                userInfo.audioCount = Int64(parsed.audioCount)
                
                userInfo.settings.bassLevel = parsed.settings.bassLevel
                userInfo.settings.boostLevel = parsed.settings.boostLevel
            }
        }
        
        Search.managedObjectContext.performAndWait {
            do{
                if Search.managedObjectContext.hasChanges{
                    try Search.managedObjectContext.save()
                }
            } catch{
                print("Что то не то")
            }
        }
    }
 
}
