//
//  FeedCellTableViewCell.swift
//  Parsegram
//
//  Created by David Heffernan on 11/1/17.
//  Copyright © 2017 David Heffernan. All rights reserved.
//

import UIKit

class FeedCellTableViewCell: UITableViewCell {
    
    let alphaShade: CGFloat = 0.4
    
    var dataSource : PostData! {
        didSet{
            print("Data Source set")
            authorLabel.text = dataSource.author.name
            contentLabel.text = dataSource.content
            //scoreLabel.text = "\(dataSource.score)"
            tElsapedLabel.text = PostData.getDateAsString(source: dataSource.date)
            commentLabel.text = "Comments: \(dataSource.commentCount)"
            
            postScore = dataSource.score
            currentLikePref = dataSource.myLikePref
       
            createShadow()
            
        }
    }
    
    var postScore: Int! {
        didSet{
            scoreLabel.text = "\(postScore!)"
        }
    }
    
    var currentLikePref: Int! {
        didSet{
            if dataSource.myLikePref == 1{
                plusButton.alpha = 1.0
                minusButton.alpha = alphaShade
            }else if dataSource.myLikePref == -1{
                plusButton.alpha = alphaShade
                minusButton.alpha = 1.0
            }else{
                plusButton.alpha = alphaShade
                minusButton.alpha = alphaShade
            }
        }
    }
    
    @IBOutlet weak var whiteView: UIView!
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var tElsapedLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
   
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func decrementScore(_ sender: UIButton) {
        if dataSource.myLikePref == -1{
            dataSource.resetLikePref()
        }else {
            dataSource.dislikePost()
        }
        dynamicUpdate()
        animateButton(target: sender)
    }

    @IBAction func incrementScore(_ sender: UIButton) {
        if dataSource.myLikePref == 1{
            dataSource.resetLikePref()
        }else {
            dataSource.likePost()
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
        currentLikePref = dataSource.myLikePref
        postScore = dataSource.score
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func createShadow(){
        whiteView.layer.shadowColor = UIColor(red: 38/255, green: 91/255, blue: 101/255, alpha: 1.0).cgColor
        whiteView.layer.shadowOpacity = 0.3
        whiteView.layer.shadowOffset = CGSize(width: 1, height: 1)
        whiteView.layer.shadowRadius = 1
        //whiteView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: whiteView.frame.width, height: whiteView.frame.height)).cgPath
        
    }
}
