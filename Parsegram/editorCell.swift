//
//  editorCell.swift
//  Parsegram
//
//  Created by David Heffernan on 11/3/17.
//  Copyright © 2017 David Heffernan. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class editorCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var heightContstraint: NSLayoutConstraint!
    
    var parentTableView: UITableView!
    
    @IBOutlet weak var whiteView: UIView!{
        didSet{
            whiteView.layer.shadowColor = UIColor(red: 38/255, green: 91/255, blue: 101/255, alpha: 1.0).cgColor
            whiteView.layer.shadowOpacity = 0.3
            whiteView.layer.shadowOffset = CGSize(width: 1, height: 1)
            whiteView.layer.shadowRadius = 1
            whiteView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: whiteView.frame.width, height: whiteView.frame.height)).cgPath
        }
    }
    
    @IBOutlet weak var textWriter: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textWriter.delegate = self
        reset()
    }
    
    func reset(){
        textWriter.text = ""
        textWriter.placeholder = "Write your own post"
        textWriter.placeholderColor = UIColor.lightGray
        sendButton.isHidden = true
        sendButton.isEnabled = false
        countLabel.text = "0/250"
        countLabel.isHidden = true
        sendButton.setTitleColor(UIColor.lightGray, for: .normal)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
      print("should begin editing")
        whiteView.frame.size.height = 130
        heightContstraint.constant = 130
        contentView.frame.size.height = 130
        sendButton.isHidden = false
        countLabel.isHidden = false
        
        parentTableView.beginUpdates()
        parentTableView.endUpdates()
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
       print("begin editing")
       

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        if (text == "\n") {
                Feed.creatingPostNow = true
                Feed.currentPostContent = textWriter.text
                textView.resignFirstResponder()
                return false
        }
        
        let currentText:NSString = textView.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with:text)
        
        var length = updatedText.count
        if length > 250{
            let endInedex = updatedText.index(updatedText.startIndex, offsetBy: 249)
            let holder = updatedText[...endInedex]
            textView.text = String(holder)
            length = holder.count
        }
        countLabel.text = "\(length)/250"
        if length < 251 && length != 0 {
            sendButton.setTitleColor(UIColor(red: 51/255, green: 149/255, blue: 164/255, alpha: 1.0), for: .normal)
            sendButton.isEnabled = true
        }else{
            sendButton.isEnabled = false
            sendButton.setTitleColor(UIColor.lightGray, for: .normal)
           
        }
        
        return true
    }
    
    @IBAction func createPost(_ sender: Any) {
       Feed.creatingPostNow = true
        Feed.currentPostContent = textWriter.text
      textWriter.resignFirstResponder()
        reset()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        whiteView.frame.size.height = 60
        heightContstraint.constant = 60
        contentView.frame.size.height = 60
        reset()
        parentTableView.beginUpdates()
        parentTableView.endUpdates()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        print("Content creator: resiging responder")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
