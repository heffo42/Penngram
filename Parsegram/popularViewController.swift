//
//  popularViewController.swift
//  Parsegram
//
//  Created by David Heffernan on 11/2/17.
//  Copyright © 2017 David Heffernan. All rights reserved.
//

import UIKit

class popularViewController: Feed {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadFeedData(param: 2)
        contentParam = 2

        let attributes = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Light", size: 26)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        
        
        //self.navigationController?.navigationBar.
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
