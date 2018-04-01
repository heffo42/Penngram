//
//  PostData.swift
//  Parsegram
//
//  Created by David Heffernan on 11/1/17.
//  Copyright © 2017 David Heffernan. All rights reserved.
//

import Foundation
import Parse

class PostData {
    
    var ParseObject: PFObject! {
        didSet{
            print("Parseobject set. Now updating values")
            score = (ParseObject.object(forKey: "score") as! NSNumber).intValue
            uniqueID = ParseObject.objectId!
            date = ParseObject.createdAt!
            schoolID = (ParseObject["schoolID"] as! String)
            author = (name: (ParseObject["authorName"] as! String), id: (ParseObject["authorID"] as! String))
            content = ParseObject["content"] as! String
            commentCount = (ParseObject.object(forKey: "commentCount") as! NSNumber).intValue
            
            
            var likers = (ParseObject.object(forKey: "likers") as! Array<String>)
            var dislikers = (ParseObject.object(forKey: "dislikers") as! Array<String>)
          
            if likers.contains(LifeData.myID){
                myLikePref = 1
            }else if dislikers.contains(LifeData.myID){
                myLikePref = -1
            }else{
                myLikePref = 0
            }
            
            let query = PFQuery(className: "Comment")
            query.whereKey("parent", equalTo: ParseObject)
            query.findObjectsInBackground {
                (objects: [PFObject]?, error: Error?) -> Void in
                    if error == nil {
                        // The find succeeded.
                        print("Comments: \(objects!.count)")
                        // Do something with the found objects
                       if let objects = objects {
                            for object in objects {
                                var tempData = commentItem()
                               tempData.parseComment = object
                                self.commentArray.append(tempData)
                            }
                        }else{
                            print("error found")
                        }
                    }
                
            }}}
    var score: Int = 0
    var age: Int = 0
    var uniqueID: String = "pre"
    var schoolID: String = "pre"
    var author: (name: String, id: String) = ("name", "id")
    var content: String = "Hello World"
    var commentArray : [commentItem] = []
    var commentCount: Int = 0
    var myLikePref: Int = 0
    var date: Date = Date()
    //-1 = dislike | 0 = no opinion | 1 = like
    
    //var likers: [String] = []
    //var dislikers: [String] = []
    
    func likePost(){
        //Invariance: cannot have liked the post already
        var incAmount: NSNumber = 1
        
        ParseObject.add(LifeData.myID, forKey: "likers")
        if myLikePref == -1 {
            ParseObject.remove(LifeData.myID, forKey: "dislikers")
            incAmount = 2
        }
        myLikePref = 1
        score = score + incAmount.intValue
        
        ParseObject.incrementKey("score", byAmount: incAmount)
        ParseObject.saveInBackground()
    }
    
    func dislikePost(){
        ParseObject.add(LifeData.myID, forKey: "dislikers")
        var decAmount: NSNumber = -1
        if myLikePref == 1{
            ParseObject.remove(LifeData.myID, forKey: "likers")
            decAmount = -2
        }
        
        myLikePref = -1
        score = score + decAmount.intValue
        
        ParseObject.incrementKey("score", byAmount: decAmount)
        ParseObject.saveInBackground()
        
    }
    
    func resetLikePref(){
   
        var scoreDelta = 0
        if myLikePref == 1 {
            ParseObject.remove(LifeData.myID, forKey: "likers")
            ParseObject.incrementKey("score", byAmount: -1)
            scoreDelta = -1
        }else{
            ParseObject.remove(LifeData.myID, forKey: "dislikers")
            ParseObject.incrementKey("score", byAmount: 1)
            scoreDelta = 1
        }
        myLikePref = 0
        score = score + scoreDelta
        
        ParseObject.saveInBackground()
    
        
    }
    
    func appendComment(commentContent: String){
        //incremenet comment  count
        commentCount = commentCount + 1
        //commentarray . append
        var tempCom = commentItem()
        tempCom.author = (LifeData.myAuthor, LifeData.myID)
        tempCom.content = commentContent
        commentArray.append(tempCom)
        tempCom.executeSelfSave(postID: uniqueID)
        ParseObject.incrementKey("commentCount")
        ParseObject.saveInBackground()
    }
    
    static func getDateAsString(source: Date) -> String{
        let timeInSec = source.timeIntervalSinceNow * -1
        
        
        //minute = 60, hour = 3600, day = 86400, week 604,800, month = 18,144,000
        
        if timeInSec < 60{
            return "Seconds ago"
        }else if timeInSec < 3600 {
            return "\(Int(timeInSec / 60)) minutes"
        }else if timeInSec < 86400{
            return "\(Int(timeInSec / 3600)) hours"
        }else if timeInSec < 604800{
             return "\(Int(timeInSec / 86400)) days"
        }else if timeInSec < 18144000{
           return "\(Int(timeInSec / 604800)) weeks"
        } else{
            return "months"
        }
    }
    
    
}
class commentItem {
    var parseComment: PFObject! {
        didSet{
            author = (name: (parseComment["authorName"] as! String), id: (parseComment["authorID"] as! String))
            content = parseComment["content"] as! String
            date = (parseComment.createdAt!)
        }
    }

    var author: (name: String, id: String) = ("name", "id")
    var content: String = "Content"
    var date: Date = Date()
    
    func executeSelfSave(postID: String){
        var myComment = PFObject(className:"Comment")
        myComment["content"] = content
        myComment["authorName"] = author.name
        myComment["authorID"] = author.id
        myComment["parent"] = PFObject(withoutDataWithClassName:"ParseFeed", objectId: postID )
        myComment.saveInBackground()
    }
}

