//
//  InfographicsViewController.swift
//  BBBAdmin
//
//  Created by Blind Joe Death on 13.09.2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import AVKit

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
    @IBOutlet weak var okButton : UIButton!
    @IBOutlet weak var audioButton : UIButton!
    @IBOutlet weak var videoButton : UIButton!
    
    var player : AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let info = userInfo{
            analyzeData(for : info)
        } else {
            okButton.isHidden = true
            audioButton.isUserInteractionEnabled = false
            videoButton.isUserInteractionEnabled = false
            Search.becomeDelegate(self)
            analyzeData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
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
        
//        let url = URL(string: "http://80.211.8.79/Home/Test/")
        
  //      downloadFileFromURL(url: url!)
    }
    
    func downloadFileFromURL(url: URL){
        
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { [weak self](URL, response, error) -> Void in
            if let error = error{
                print(error)
            }
            self?.play(url: URL!)
        })
        
        downloadTask.resume()
    }
    
    func play(url:URL) {
        print("playing \(url)")
        
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
    deinit{
        print("deinit")
    }
    
    @IBAction func loadAudios(){
        performSegue(withIdentifier: "ContentListSegue", sender: ContentListViewController.ContentType.audio)
    }
    
    @IBAction func loadVideos(){
        performSegue(withIdentifier: "ContentListSegue", sender: ContentListViewController.ContentType.video)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContentListSegue"{
            let navigationController = segue.destination as! UINavigationController
            let contentListViewController = navigationController.topViewController as! ContentListViewController
            
            contentListViewController.contentType = sender as! ContentListViewController.ContentType
            
            contentListViewController.userId = userInfo!.userId
        }
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
