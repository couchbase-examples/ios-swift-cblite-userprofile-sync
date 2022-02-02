//  UserProfileQueryDemo
//  Copyright © 2022 Couchbase Inc. All rights reserved.

import UIKit

class LoginViewController
: UIViewController {
    
    @IBOutlet weak var passwordTextEntry: UITextField!
    @IBOutlet weak var userTextEntry: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    
    // MARK: View Related
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func touchesShouldCancelInContentView(_ view: UIView) -> Bool {
        return true
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.passwordTextEntry.text = nil
        self.userTextEntry.text = nil
    }
}


// MARK: UITextFieldDelegate
extension LoginViewController : UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        if textField == self.passwordTextEntry {
            textField.resignFirstResponder()
            onLoginTapped(loginButton)
        }
        else if textField == self.userTextEntry {
            textField.resignFirstResponder()
            self.passwordTextEntry.becomeFirstResponder()
        }
        return true;
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let length = (textField.text?.count)! - range.length + string.count
        let userLength = (textField == self.userTextEntry) ? length : self.userTextEntry.text?.count
        let passwordLength = (textField == self.passwordTextEntry) ? length : self.passwordTextEntry.text?.count
        
        self.loginButton.isEnabled = (userLength! > 0 && passwordLength! > 0)
        
        return true;
    }
}

// MARK : IBOutlet handlers
extension LoginViewController {
    @IBAction func onLoginTapped(_ sender: UIButton) {
        if let userName = self.userTextEntry.text, let password = self.passwordTextEntry.text {
            let cbMgr = DatabaseManager.shared
            
            // First open prebuilt DB with content common to all users
            cbMgr.openPrebuiltDatabase(handler: { [weak self](error) in
                guard let `self` = self else {
                    return
                }
                switch error {
                case nil:
                    
                    self.activitySpinner.startAnimating()
                    cbMgr.openOrCreateDatabaseForUser(userName, password: password, handler: { [weak self](error) in
                        guard let `self` = self else {
                            return
                        }
                        switch error {
                        case nil:
                            NotificationCenter.default.post(Notification.notificationForLoginSuccess(userName))
                            self.activitySpinner.stopAnimating()
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileNVC")
                            self.present(vc!, animated: true, completion: nil)
                            
                        default:
                            NotificationCenter.default.post(Notification.notificationForLoginFailure(userName))
                            self.activitySpinner.stopAnimating()
                        }
                    })
                default:
                    self.activitySpinner.startAnimating()
                    NotificationCenter.default.post(Notification.notificationForLoginFailure(userName))
                    self.activitySpinner.stopAnimating()
                }
            })
        }
    }
}
