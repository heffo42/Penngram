//
//  loginView.swift
//  Parsegram
//
//  Created by David Heffernan on 11/2/17.
//  Copyright © 2017 David Heffernan. All rights reserved.
//

import UIKit

class WelcomeView: UIViewController {

 
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        let color1 = UIColor(red: (12/255), green: (93/255), blue: (151/255), alpha: 0.4).cgColor as CGColor
        let color2 = UIColor(red: (44/255), green: (168/255), blue: (194/255), alpha: 1.0).cgColor as CGColor
        let color3 = UIColor(red: (49/255), green: (240/255), blue: (156/255), alpha: 0.4).cgColor as CGColor
        gradientLayer.colors = [color1, color2, color3]
        gradientLayer.locations = [0.0, 0.3,0.85]
        //gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        //gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        gradientLayer.startPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
    }
    

    @IBAction func signUpAction(_ sender: Any) {
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
