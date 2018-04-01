//
//  Feed.swift
//  Parsegram
//
//  Created by David Heffernan on 11/1/17.
//  Copyright © 2017 David Heffernan. All rights reserved.
//

import UIKit
import Parse

class Feed: UITableViewController {

    static var reloadAllowed = true
     var feedData: [PostData] = []
    static var creatingPostNow = false
    static var currentPostContent = ""
    
    //1 = general, 2 = fuego, 3 = my view
    var contentParam = 1
    var shouldAnimateFirstRow = false
    var shouldAnimateAtIndex = IndexPath(row: 0, section: 1)
    var lastQueryCount = 25
    
    
    @IBOutlet weak var navCompose: UIBarButtonItem!
    

    
    var editorCellSelected: Bool = false
    
    
    var myEditCell: editorCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.tableView.register(editorCell(), forCellReuseIdentifier: "cellCreate")
        tableView.estimatedRowHeight = 130
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        LifeData.testInit()
         self.navigationController?.navigationBar.tintColor = UIColor.white
        //TESTING TODO
        //loadFeedData()

      
         let refreshControlLocal = UIRefreshControl()
        refreshControl = refreshControlLocal
        refreshControlLocal.addTarget(self, action: #selector(refreshFeed(_:)), for: .valueChanged)
        refreshControl?.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        //refreshControl?.attributedTitle = NSAttributedString(string: "Fetching New Posts ...", attributes: [:])
        
        navCompose.action = #selector(Feed.navComposeWriter)
        navCompose.target = self
        
                /*
         if #available(iOS 10.0, *) {
         tableView.refreshControl = refreshControl
         } else {
         tableView.addSubview(refreshControl)
         }
         */
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func navComposeWriter(){
        
        if editorCellSelected{
            //close and change icon to plus
            myEditCell.textWriter.resignFirstResponder()
            navCompose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(Feed.navComposeWriter))
        }else{
            //open and change icom to minus
        myEditCell.textWriter.becomeFirstResponder()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        //editorCellSelected = !editorCellSelected

    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if(!myEditCell.textWriter.isFirstResponder){
         myEditCell.textWriter.becomeFirstResponder()
        }
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        print("keyboard will show in feed")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(Feed.navComposeWriter))
        editorCellSelected = true
    }
    
    
    
    @objc func keyboardWillHide(sender: NSNotification) {
        print("kyboard will hide in feed")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(Feed.navComposeWriter))
        editorCellSelected = false
        
        if Feed.creatingPostNow{
            createNewPost(content: Feed.currentPostContent)
            Feed.creatingPostNow = false
        }
        
        }
    


    
    @objc func refreshFeed(_ sender: Any){
        //loadFeedData(param: contentParam)
        refreshMyCurrentData()
    }
    
    func dataUnqiue(uniqueID: String) -> Bool{
        for post in feedData{
            if post.uniqueID == uniqueID {
                return false
            }
        }
        return true
    }
    
    /*
    static func addElementToData(element toAdd: PostData, reloadStyle: Int){
        feedData.append(toAdd)
        if(reloadStyle == 1){
            
        }
    }
    */
    
    override func viewDidAppear(_ animated: Bool) {
        print("View Did Appear")
         //loadFeedData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
            return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0{
            return 1
        }else{
           return feedData.count
        }
        

    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
      //  let cellIdentifier = tableView.cellForRow(at: indexPath)?.reuseIdentifier
        print("Section: \(indexPath.section), Row: \(indexPath.row)")
        if  indexPath.section == 0  {
            print("Creating editor cell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellCreate", for: indexPath)
            if let myEditCellLocal = cell as? editorCell{
                print("Is edit cell")
                myEditCell = myEditCellLocal
                myEditCellLocal.parentTableView = self.tableView
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            print("returning cell")
            return cell
            
        }else {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath)
        print("Attempting to make cell for author: \(feedData[indexPath.row].author.name)")
        
        if let myFeedCell = cell as? FeedCellTableViewCell {
            print("Creating cell #: \(indexPath.row)")
            myFeedCell.dataSource = feedData[indexPath.row]
        }

            if(indexPath.row == feedData.count - 1){
                addMoreDate()
            }
            
        // Configure the cell...

        return cell
        }
        
    }
    
    func createNewPost(content: String){
        print("Pending post creating with content: \(content)")
        
        
        var pd = PostData()
        pd.score = 0
        pd.author = (LifeData.myAuthor, LifeData.myID)
        pd.content = content
        pd.date = Date()
        pd.commentCount = 0
        
      
        //feedData.insert(pd, at: 0)
        
        let queue = DispatchQueue.main
        queue.async {
            self.tableView.beginUpdates()
            self.feedData.insert(pd, at: 0)
            let indexPath = IndexPath(row: 0, section: 1)
            self.tableView.insertRows(at: [indexPath], with: .top)
            self.shouldAnimateFirstRow = true
            self.tableView.endUpdates()
        }
        
        var pfPost = PFObject(className: "ParseFeed")
        pfPost["content"] = content
        pfPost["authorName"] = LifeData.myAuthor
        pfPost["authorID"] = LifeData.myID
        pfPost["schoolID"] = LifeData.mySchool.id
        pfPost["score"] = 0
        pfPost["commentCount"] = 0
        pfPost["likers"] = []
        pfPost["dislikers"] = []
        pfPost.saveInBackground() {
            (success: Bool, error: Error?) in
            if (success){
                  pd.ParseObject = pfPost
               
                
            } else{
                
            }
        }
        
    }
    
   override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath == shouldAnimateAtIndex && shouldAnimateFirstRow {
            animateIn(cell: cell, withDelay: 0.7)
            shouldAnimateFirstRow = false
        }
    }
    
    fileprivate func animateIn(cell: UITableViewCell, withDelay delay: TimeInterval) {
        let initialScale: CGFloat = 1.2
        let duration: TimeInterval = 0.5
        
        cell.alpha = 0.0
        cell.layer.transform = CATransform3DMakeScale(initialScale, initialScale, 1)
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseOut, animations: {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 && contentParam == 1{
            return nil
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        /*print("Creating Comment")
        var myComment = PFObject(className:"Comment")
        myComment["content"] = "Let's do Sushirrito."
        myComment["authorName"] = "Philip"
        myComment["authorID"] = "uniqueID"
        myComment["parent"] = PFObject(withoutDataWithClassName:"ParseFeed", objectId: feedData[indexPath.row].uniqueID)
        myComment.saveInBackground()*/
        
        //performSegue(withIdentifier: "ToCatPics", sender: tableView.cellForRow(at: indexPath))
        // performSegue(withIdentifier: "toCommentView", sender: tableView.cellForRow(at: indexPath))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func loadFeedData(param: Int) {
        contentParam = param
        print("Loading feed")
        let query = PFQuery(className:"ParseFeed")
        query.whereKey("schoolID", equalTo: LifeData.mySchool.id)
        //0 = date, 1 = name
        if param == 1{
        query.order(byDescending: "createdAt")
        }else if param == 2{
            query.order(byDescending: "score")
        }else if param == 3{
            query.whereKey("author", equalTo: LifeData.myAuthor)
        }
        query.limit = 25
        query.skip = feedData.count
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                self.lastQueryCount = objects!.count
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object.objectId ?? "No ID found")
                        var tempData = PostData()
                        tempData.ParseObject = object
                        if(self.dataUnqiue(uniqueID: tempData.uniqueID)){
                            self.feedData.append(tempData)
                        }
                    }
                    self.refreshControl?.endRefreshing()
                    
                    self.tableView.reloadData()
                    
                }
            } else {
                
                // Log details of the failure
                //print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }
    
    
    func refreshMyCurrentData(){
        
        print("Loading feed")
        let query = PFQuery(className:"ParseFeed")
        query.whereKey("schoolID", equalTo: LifeData.mySchool.id)
        //0 = date, 1 = name
        if contentParam == 1{
            query.order(byDescending: "createdAt")
        }else if contentParam == 2{
            query.addDescendingOrder("score")
        }else if contentParam == 3{
            query.whereKey("author", equalTo: LifeData.myAuthor)
        }
        query.limit = feedData.count + 10
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in

            if error == nil {
             var insertCounter = 0
             var indexCounter = 0
           
                if let objects = objects {
                    for object in objects {
                        
                       // print("Updating... \(object.objectId!) with potentail")
                        
                        if insertCounter + indexCounter > self.feedData.count - 1{
                            //grabbed extra
                        }else if object.objectId! != self.feedData[indexCounter].uniqueID{
                            print("Inserting a new object")
                            self.tableView.beginUpdates()
                            var pd = PostData()
                            pd.ParseObject = object
                            self.feedData.insert(pd, at: insertCounter)
                            let indexPath = IndexPath(row: insertCounter, section: 1)
                            self.tableView.insertRows(at: [indexPath], with: .top)
                            self.shouldAnimateFirstRow = true
                            self.shouldAnimateAtIndex = indexPath
                            insertCounter = insertCounter + 1
                            indexCounter = indexCounter + 1
                            self.tableView.endUpdates()
                        }else{
                            //update parse object
                            if object.objectId! == self.feedData[insertCounter + indexCounter].uniqueID{
                                print("We have a match and can update")
                            }
                            indexCounter = indexCounter + 1
                        }
                        
                    }
                    
                    self.refreshControl?.endRefreshing()
                    
                   // self.tableView.reloadData()
                    
                }
            } else {
                
                // Log details of the failure
                //print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }
 
    func addMoreDate(){
        if lastQueryCount != 0{
        loadFeedData(param: contentParam)
        }
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let commentHead = segue.destination as? commentController, let cell = sender as? FeedCellTableViewCell{
            commentHead.viewData = cell.dataSource
        }
        
    }
 

}
