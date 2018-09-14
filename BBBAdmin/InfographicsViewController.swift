//
//  InfographicsViewController.swift
//  BBBAdmin
//
//  Created by Blind Joe Death on 13.09.2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import UIKit
import CoreData

class InfographicsViewController: UIViewController {
    
    var userInfo : UserInfo? = nil
    
    var managedObjectContext : NSManagedObjectContext!
    
    var audioCount : Int64 = 0
    var videoCount : Int64 = 0
    var audioMessageCount : Int64 = 0
    var videoMessageCount : Int64 = 0
    
    @IBOutlet weak var videoCountLabel : UILabel!
    @IBOutlet weak var videoMessageCountLabel : UILabel!
    @IBOutlet weak var audioCountLabel : UILabel!
    @IBOutlet weak var audioMessageCountLabel : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let info = userInfo{
            analyzeData(for : info)
        } else {
            Search.becomeDelegate(self)
            analyzeData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func analyzeData(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        
        var fetchedData : [UserInfo]! = nil
        managedObjectContext.performAndWait{
            do {
                fetchedData = try managedObjectContext.fetch(fetchRequest) as! [UserInfo]
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        }
        
        audioCount = 0
        videoCount  = 0
        audioMessageCount = 0
        videoMessageCount = 0
        
        for info in fetchedData{
            audioCount += info.audioCount
            videoCount += info.videoCount
            audioMessageCount += info.audioMessageCount
            videoMessageCount += info.videoMessageCount
        }
        
        updateUI()
    }
    
    private func analyzeData(for userInfo : UserInfo){
        audioCount = userInfo.audioCount
        videoCount = userInfo.videoCount
        audioMessageCount = userInfo.audioMessageCount
        videoMessageCount = userInfo.videoMessageCount
        
        updateUI()
    }
    
    private func updateUI(){
        videoCountLabel.text = String(videoCount)
        videoMessageCountLabel.text = String(videoMessageCount)
        audioCountLabel.text = String(audioCount)
        audioMessageCountLabel.text = String(audioMessageCount)
    }
    
    deinit{
        print("deinit")
    }
}

extension InfographicsViewController : SearchListenerDelegate{
    func searchDone(success: Bool) {
        if !success{
            present(networkErrorAlert(), animated: true, completion: nil)
        } else {
            analyzeData()
        }
    }
}
