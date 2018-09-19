//
//  ContentListViewController.swift
//  BBBAdmin
//
//  Created by Blind Joe Death on 19.09.2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import UIKit

class ContentListViewController: UITableViewController {
    
    enum ContentType : String, CustomStringConvertible{
        case audio = "Audio"
        case video = "Video"
        
        var description: String{
            get{
                return self.rawValue
            }
        }
    }
    var contentType : ContentType!
    var userId : String!
    
    private var fileNames : [String] = []
    private var dataTask: URLSessionDataTask? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFileNames()
    }
    
    func loadFileNames(){
        
        let url = URL(string: "http://80.211.8.79/Home/GetFileNames?key=\(appKey)&userId=\(String(userId))&type=\(contentType.description)")
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let session = URLSession.shared
        dataTask = session.dataTask(with: url!, completionHandler: {
            data, response, error in
            
            let exitClosure : (Bool) -> Void = {result in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    if result{
                        self.tableView.reloadData()
                    } else {
                        self.present(networkErrorAlert(), animated: true, completion: nil)
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
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let parsed = json as? [String]{
                
                self.fileNames = parsed
                
                success = true
            }
            exitClosure(success)
        })
        
        dataTask?.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentListCell",
                                                 for: indexPath)
        
        cell.textLabel?.text = fileNames[indexPath.row]

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
