//
//  WritePost.swift
//  Parsegram
//
//  Created by David Heffernan on 11/2/17.
//  Copyright © 2017 David Heffernan. All rights reserved.
//

import UIKit
import Parse

class WritePost: UIViewController {

   
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var contentWriter: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postButton.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 5
        contentWriter.layer.cornerRadius = 5
        contentWriter.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postContent(_ sender: UIButton) {
        /*
        
        var pfPost = PFObject(className: "ParseFeed")
        pfPost["content"] = contentWriter.text!
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
               var  pd = PostData()
                pd.ParseObject = pfPost
                Feed.feedData.append(pd)
                self.dismiss(animated: true, completion: nil)
                
            } else{
                
            }
        }
        
        */
    }
    @IBAction func cancelPost(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        bottomConstraint.constant = (keyboardSize - bottomLayoutGuide.length) + 10
        
        let duration: TimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
    
   /* @objc func keyboardWillHide(sender: NSNotification) {
        let info = sender.userInfo!
        let duration: TimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        bottomConstraint.constant = 0
        
        UIView.animate(withDuration: duration) {
            self.dismiss(animated: true, completion: nil)
            //self.view.layoutIfNeeded()
            
        }
    }*/
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
