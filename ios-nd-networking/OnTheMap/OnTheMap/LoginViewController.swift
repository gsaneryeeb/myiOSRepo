//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by JasonZhang on 21/12/2016.
//  Copyright © 2016 Saneryee. All rights reserved.
//

import UIKit

// MARK: - LoginViewController: UIViewCOntroller

class LoginViewController: UIViewController,UINavigationControllerDelegate {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var keyboardOnScreen = false
    
    // MARK: Outlets
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var udcityLogoImageView: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get the app delegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        configureBackground()
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugTextLabel.text = ""
    }
    
    // MARK: Login
    
    @IBAction func loginPressed(_ sender: AnyObject){
        
        userDidTapView(self)
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            debugTextLabel.text = "Username or Password Empty."
        } else {
            setUIEnable(false)
            UdacityClient.sharedInstance().authenticateWithAPI(usernameTextField.text!,passwordTextField.text!){(success,errorString) in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                    } else {
                        self.showErrorAlert(errorString!)
                    }
                }
            }
            
        }
    }

    // MARK: Login
    
    private func completeLogin() {
        //self.debugTextLabel.text = ""
        self.setUIEnable(true)
        
        // Add Buttons on top
        // The first way would be to embed a navigation view controller and present the NavController instead
        // of the TabController. The NavController will automatically present the TabController.
        // NavController> TabController >
        // https://discussions.udacity.com/t/help-with-getting-navbar-items-on-tabbarcontroller-i-e-logout-dropapin-referesh-icons/162709/6
        
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "showOnTheMap") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: showErrorAlert
    
    func showErrorAlert(_ error : String){
        
        let alert = UIAlertController(title: "", message: error, preferredStyle: UIAlertControllerStyle.alert
        )
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}


// MARK: - LoginViewController: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
            udcityLogoImageView.isHidden = true
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
            udcityLogoImageView.isHidden = false
        }
    }
    
    func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    private func resignIfFirstResponder(_ textField: UITextField){
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(usernameTextField)
        resignIfFirstResponder(passwordTextField)
    }
}

// MARK: - LoginViewController (Configure UI)

private extension LoginViewController {
    
    func setUIEnable(_ enabled: Bool){
        usernameTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        debugTextLabel.text = ""
        debugTextLabel.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
        
    }
    
    func displayError(_ errorString: String?){
        if let errorString = errorString{
            debugTextLabel.text = errorString
        }
    }
    
    func configureBackground(){
        
        // configure background gradient
        // from Top to bottom
        let backgroundGradient = CAGradientLayer()
        let colorTop = UIColor(red: 0.898, green: 0.659, blue: 0.188, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 0.898, green: 0.455, blue: 0.227, alpha: 1.0).cgColor
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, at: 0)
        
        
        
    }
    
    func configureTextField(_ textField: UITextField) {
        let textFieldPaddingViewFrame = CGRect(x: 0.0, y: 0.0, width: 13.0, height: 0.0)
        let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
        textField.leftView = textFieldPaddingView
        textField.leftViewMode = .always
        textField.backgroundColor = UIColor(red: 0.702, green: 0.863, blue: 0.929, alpha:1.0)
        textField.textColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.white])
        textField.tintColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        textField.delegate = self
    }
}

// MARK: - LoginViewController (Notification)

private extension LoginViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications(){
        NotificationCenter.default.removeObserver(self)
    }
}



