//
//  commentCell.swift
//  Parsegram
//
//  Created by David Heffernan on 11/3/17.
//  Copyright © 2017 David Heffernan. All rights reserved.
//

import UIKit

class commentCell: UITableViewCell {

    var dataSource: commentItem! {
        didSet{
            authorLabel.text = dataSource.author.name
            dateLabel.text = PostData.getDateAsString(source: dataSource.date)
            contentLabel.text = dataSource.content
        }
    }
    
    @IBOutlet weak var maxWidthContraint: NSLayoutConstraint!
    @IBOutlet weak var grayView: UIView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        grayView.layer.cornerRadius = 8
        //maxWidthContraint.constant = superview?.frame.width - 100
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
