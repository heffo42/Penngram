//
//  commentController.swift
//  Parsegram
//
//  Created by David Heffernan on 11/2/17.
//  Copyright © 2017 David Heffernan. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class commentController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{
    

   
    @IBOutlet weak var navCompose: UIBarButtonItem!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var expandHeight: NSLayoutConstraint!
    
    var viewData: PostData = PostData()
    
    @IBOutlet weak var authorLabel: UILabel! {
        didSet{
            authorLabel.text = viewData.author.name
        }
    }
    @IBOutlet weak var contentLabel: UILabel! {
        didSet{
            contentLabel.text = viewData.content
        }
    }
    @IBOutlet weak var scoreLabel: UILabel! {
        didSet{
            scoreLabel.text = "\(viewData.score)"
        }
    }
    @IBOutlet weak var dateLabel: UILabel! {
        didSet{
            //dateLabel.text = viewData.formattedDate()
            dateLabel.text = PostData.getDateAsString(source: viewData.date)
        }
    }
    @IBOutlet weak var commentLabel: UILabel! {
        didSet{
            setCommentLabelContent()
        }
    }
    
    let alphaShade: CGFloat = 0.4
    var currentLikePref: Int! {
        didSet{
            if viewData.myLikePref == 1{
                upButton.alpha = 1.0
                downButton.alpha = alphaShade
            }else if viewData.myLikePref == -1{
                upButton.alpha = alphaShade
                downButton.alpha = 1.0
            }else{
                upButton.alpha = alphaShade
                downButton.alpha = alphaShade
            }
        }
    }
    
    @IBOutlet weak var upButton: UIButton!{
        didSet{
            currentLikePref = viewData.myLikePref
        }
    }
    @IBOutlet weak var downButton: UIButton!
    
    @IBOutlet weak var replyWriter: UITextView!
    @IBOutlet weak var commentTable: UITableView!
   
    
    
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var postButton: UIButton!
    var bgLabel = UILabel()
    
    let placeHolder = "Write a comment"
    
    @IBOutlet weak var holder: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTable.delegate = self
        commentTable.dataSource = self
        commentTable.allowsSelection = false
        
        replyWriter.delegate = self
        replyWriter.text = ""
        replyWriter.placeholder = "Write a comment"
        replyWriter.placeholderColor = UIColor.lightGray
        replyWriter.enablesReturnKeyAutomatically = true
        postButton.isEnabled = false
        
        
        roundedView.layer.cornerRadius = 5
        roundedView.layer.borderWidth = 1
        roundedView.layer.masksToBounds = false
        roundedView.layer.borderColor =  UIColor(red: (30/255), green: (170/255), blue: (191/255), alpha: 1).cgColor
        roundedView.clipsToBounds = true

        navCompose.action = #selector(navComposeClick)
        navCompose.target = self
        
        commentTable.estimatedRowHeight = 80
        commentTable.rowHeight = UITableViewAutomaticDimension
        
       
        
    }
    
    func createEmptyLabel(){
        bgLabel.textAlignment = .center
        
        bgLabel.text = "Be the first to write a comment"
        commentTable.backgroundView = bgLabel
    }
    
     @objc func navComposeClick(){
        if(replyWriter.isFirstResponder){
            replyWriter.resignFirstResponder()
            replyWriter.text = ""
        }else{
            replyWriter.becomeFirstResponder()
        }
    }
    
    func setCommentLabelContent(){
        if viewData.commentCount == 1{
            commentLabel.text = "1 comment"
        }else{
            commentLabel.text = "\(viewData.commentCount) comments"
        }
    }
    
    func checkEligible(content: String) -> Bool{
        if content.count != 0  && content.count <= 200{
            postButton.isEnabled = true
            return true
        }else{
            postButton.isEnabled = false
            return false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText:NSString = textView.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with:text)
        checkEligible(content: updatedText)
        //Did they press send
        if (text == "\n") {
            textView.resignFirstResponder()
            if postButton.isEnabled{
                postActionHandle()
            }
            return false
        }
        
        if updatedText.count < 200 {
            return true
        }else{
            return false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        replyWriter.resignFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        //resignFirstResponder()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if viewData.commentArray.count == 0{
             createEmptyLabel()
        }else{
            bgLabel.isHidden = true
        }
        
        return viewData.commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        
        if let myCell = cell as? commentCell{
            myCell.dataSource = viewData.commentArray[indexPath.row]
        }
        
        return cell
    }
    
    @IBAction func upVoteAction(_ sender: UIButton) {
        if viewData.myLikePref == 1{
            viewData.resetLikePref()
        }else {
            viewData.likePost()
        }
        dynamicUpdate()
        animateButton(target: sender)
    }
    
    @IBAction func downVoteAction(_ sender: UIButton) {
        if viewData.myLikePref == -1{
            viewData.resetLikePref()
        }else {
            viewData.dislikePost()
        }
        dynamicUpdate()
       animateButton(target: sender)
    }
    
    func animateButton(target: UIButton){
        target.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        target.transform = .identity
            },
                       completion: nil)
    }
    
    func dynamicUpdate(){
        currentLikePref = viewData.myLikePref
        scoreLabel.text = "\(viewData.score)"
    }
    
    @IBAction func postAction(_ sender: Any) {
        postActionHandle()
    }
    
    func postActionHandle(){
        viewData.appendComment(commentContent: replyWriter.text )
        replyWriter.resignFirstResponder()
        commentTable.reloadData()
        postButton.isEnabled = false
        replyWriter.text = ""
        setCommentLabelContent()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        replyWriter.enablesReturnKeyAutomatically = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(navComposeClick))
        let info = sender.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        bottomConstraint.constant = (keyboardSize - bottomLayoutGuide.length) + 10
        
        let duration: TimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
    
     @objc func keyboardWillHide(sender: NSNotification) {
     self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(navComposeClick))
     let info = sender.userInfo!
     let duration: TimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
     bottomConstraint.constant = 0
     
     UIView.animate(withDuration: duration) {
     self.view.layoutIfNeeded()
     
     }
        

        
}

    // MARK: - Table view data source

   

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
