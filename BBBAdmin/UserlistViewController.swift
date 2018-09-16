//
//  UserlistViewController.swift
//  BBBAdmin
//
//  Created by Blind Joe Death on 10.09.2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class UserlistViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var darkView: UIView!
    
    struct UserlistViewIdentifiers{
        static let userInfoCell  = "UserInfoCell"
        static let rjumanSpinnerView = "RjumanSpinnerView"
    }
    
    private var filteredData : [UserInfo] = []
    private var isSearching = false
    private var rjumanSpinnerView : RjumanSpinnerView!
    private var refreshControl : UIRefreshControl!
    
    var managedObjectContext : NSManagedObjectContext!
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<UserInfo> = {
       let fetchRequest: NSFetchRequest<UserInfo> = NSFetchRequest<UserInfo>(entityName: "UserInfo")
        
        fetchRequest.sortDescriptors = UserInfo.sortDescriptors()
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: managedObjectContext,
                                                                  sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        becomeDelegate()
        addSearchBar()
        registerNibs()
        addRefreshControl()
        performFetch()
        addGestureRecognizer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.d
    }
    
    func addGestureRecognizer(){
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("hooly")
        }
    }
    
    func addSearchBar(){
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        searchBar.returnKeyType = .done
    }
    
    func addRefreshControl(){
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.clear
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.addTarget(self, action: #selector(requestSearch), for: .valueChanged)
        rjumanSpinnerView = Bundle.main.loadNibNamed(UserlistViewIdentifiers.rjumanSpinnerView, owner: self, options: nil)?.first as! RjumanSpinnerView
        
        refreshControl.addSubview(rjumanSpinnerView)
        
        rjumanSpinnerView.frame = refreshControl.frame
        rjumanSpinnerView.backgroundColor = UIColor.clear
        
        tableView.refreshControl = refreshControl
        
        setDarkViewState(false)
    }
    
    func becomeDelegate(){
        Search.becomeDelegate(self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func registerNibs(){
        let cellNib = UINib(nibName: UserlistViewIdentifiers.userInfoCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: UserlistViewIdentifiers.userInfoCell)
    }
    
    @objc
    func requestSearch(){
        print("perform request")
        Search.performSearch()
        rjumanSpinnerView.startAnimation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserInfographics"{
            print("here 2 ")
            let infographicsViewController = segue.destination as! InfographicsViewController
            infographicsViewController.userInfo = sender as! UserInfo
        }
    }
    
    deinit {
        fetchedResultsController.delegate = nil
    }
}

extension UserlistViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.performSegue(withIdentifier: "UserInfographics",
                              sender: self.fetchedResultsController.object(at: indexPath))
        }
    }
}

extension UserlistViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(isSearching){
            return filteredData.count
        }
        
        if let sections = fetchedResultsController.sections{
            let number = sections[section].numberOfObjects
            return number
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userlistCell = tableView.dequeueReusableCell(
            withIdentifier: UserlistViewIdentifiers.userInfoCell) as! UserInfoCell
        
        let index = indexPath.row
        
        if(isSearching){
            userlistCell.configure(filteredData[index], at: index + 1)
        } else{
            userlistCell.configure(fetchedResultsController.object(at: indexPath), at: index + 1)
        }
        return userlistCell
    }
}

extension UserlistViewController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("*** controllerWillChangeContent")
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            print("*** NSFetchedResultsChangeInsert (object)")
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            print("*** NSFetchedResultsChangeDelete (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            print("*** NSFetchedResultsChangeUpdate (object)")
            if let cell = tableView.cellForRow(at: indexPath!)
                as? UserInfoCell {
                let userInfo = controller.object(at: indexPath!) as! UserInfo
                cell.configure(userInfo, at: indexPath!.row + 1)
            }
        case .move:
            print("*** NSFetchedResultsChangeMove (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {

        switch type {
        case .insert:
            print("*** NSFetchedResultsChangeInsert (section)")
            tableView.insertSections(IndexSet(integer: sectionIndex),
                                     with: .fade)
        case .delete:
            print("*** NSFetchedResultsChangeDelete (section)")
            tableView.deleteSections(IndexSet(integer: sectionIndex),
                                     with: .fade)
        case .update:
            print("*** NSFetchedResultsChangeUpdate (section)")
        case .move:
            print("*** NSFetchedResultsChangeMove (section)")
        }
    }
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
          
        print("*** controllerDidChangeContent")
        tableView.endUpdates()
    }
}

extension UserlistViewController : UISearchBarDelegate {
    
    @objc
    func dismissKeyboard() {
        setDarkViewState(false)
        view.endEditing(true)
    }
    
    func setDarkViewState(_ state : Bool){
        
//        darkView.isUserInteractionEnabled = state
        darkView.isHidden = !state
        
        var alpha = 0.0
        if (state){
            alpha = 0.4
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options:[], animations: {
            self.darkView.backgroundColor =  UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(alpha))
        }, completion:nil)
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        setDarkViewState(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        setDarkViewState(false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        setDarkViewState(false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            tableView.reloadData()
        } else {
            isSearching = true
            
            let lowerCasedText = searchText.lowercased()
            let predicate =  NSPredicate(format: """
                                            firstName CONTAINS[c] '\(lowerCasedText)' OR
                                            lastName CONTAINS[c] '\(lowerCasedText)' OR
                                            nickName CONTAINS[c] '\(lowerCasedText)'
                                            """)
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"UserInfo")
            fetchRequest.predicate = predicate
            
            managedObjectContext.performAndWait{
                do {
                    filteredData = try managedObjectContext.fetch(fetchRequest) as! [UserInfo]
                } catch let error as NSError {
                    print("Could not fetch. \(error)")
                }
            }
            
            tableView.reloadData()
        }
    }
}

extension UserlistViewController : SearchListenerDelegate{
    func searchDone(success: Bool) {
        if !success {
            present(networkErrorAlert(), animated: true, completion: nil)
        }
        
        rjumanSpinnerView.stopAnimation()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension UserlistViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        return (touch.view === darkView)
    }
}

