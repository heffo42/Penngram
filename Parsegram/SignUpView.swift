//
//  SignUpView.swift
//  Parsegram
//
//  Created by David Heffernan on 11/4/17.
//  Copyright © 2017 David Heffernan. All rights reserved.
//

import UIKit
import Parse

class SignUpView: ViewControllerPannable, UITextFieldDelegate {
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*
        createButton.layer.borderWidth = 1
        createButton.layer.borderColor = UIColor(red: (194/255), green: (194 / 255), blue: (200/255), alpha: 1.0).cgColor
        createButton.layer.cornerRadius = 5
        createButton.layer.masksToBounds = true*/
        emailText.delegate = self
        passwordText.delegate = self
        emailText.enablesReturnKeyAutomatically = true
        passwordText.enablesReturnKeyAutomatically = true
    }

    override func viewWillAppear(_ animated: Bool) {

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText:NSString = textField.text! as NSString
        let updatedText = currentText.replacingCharacters(in: range, with:string)
        
        if textField == emailText{
            if isValidEmail(testStr: updatedText){
                emailText.textColor = UIColor.white
            }else{
                emailText.textColor = UIColor.black
                
            }
        }else if textField == passwordText{
            if isValidPassword(testStr: updatedText){
                passwordText.textColor = UIColor.white
            }else{
                passwordText.textColor = UIColor.black
            }
        }
        
        if emailText.textColor == UIColor.white && passwordText.textColor == UIColor.white{
            createButton.isEnabled = true
        }else{
            createButton.isEnabled = false
        }
        
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailText{
            passwordText.becomeFirstResponder()
            return false
        }else{
            if isValidEmail(testStr: emailText.text!) && isValidPassword(testStr: passwordText.text!){
                attemptToCreateUser()
                return true
            }else{
                createInfoAlert()
                return true
            }
        }
    }
    
    func createInfoAlert(){
        var myMessage: String = ""
        if !isValidEmail(testStr: emailText.text!) && !isValidPassword(testStr: passwordText.text!){
            myMessage = "This is not a valid email address and your password is not 8 or more characters"
        }else if !isValidEmail(testStr: emailText.text!){
            myMessage = "This is not a valid email address"
        }else{
            myMessage = "Your password must be 8 or more characters"
        }
        let alert = UIAlertController(title: "Not Valid Info", message: myMessage, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            // perhaps use action.title here
        })
        self.present(alert, animated: true)
    }
    
    func createInfoAlertWith(customText content: String){
        let alert = UIAlertController(title: "Not Valid Info", message: content, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            // perhaps use action.title here
        })
        self.present(alert, animated: true)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidPassword(testStr: String) -> Bool{
        if testStr.count > 7{
            return true
        }else{
            return false
        }
    }
    
    @IBAction func createAction(_ sender: Any) {
        attemptToCreateUser()
    }
    
    func attemptToCreateUser() {
        indicator.startAnimating()
        var user = PFUser()
       // user.username = "myUsername"
        user.password = passwordText.text!
        user.username = emailText.text!
        user.email = emailText.text!
        // other fields can be set just like with PFObject
        //user["phone"] = "415-392-0202"
        
        user.signUpInBackground {
            (succeeded: Bool, error: Error?) -> Void in
            self.indicator.stopAnimating()
            if let error = error {
               // let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print("There is an error: \(error.localizedDescription)")
            } else {
                // Hooray! Let them use the app now.
                print("Go to feed")
                
            }
        }
        
    }
    
    @IBAction func downAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func cutstomTapAction() {
        print("Sign Up Tapped")
        if emailText.isFirstResponder {
            emailText.resignFirstResponder()
        }else if passwordText.isFirstResponder{
            passwordText.resignFirstResponder()
        }
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
