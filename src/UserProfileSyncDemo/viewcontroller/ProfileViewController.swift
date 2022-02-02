//  UserProfileQueryDemo
//  Copyright © 2022 Couchbase Inc. All rights reserved.

import Foundation
import UIKit

class ProfileViewController
    : UIViewController, UserPresentingViewProtocol {
    
    fileprivate var record:UserRecord?
    fileprivate var imageUpdated:Bool = false
    lazy var userPresenter:UserPresenter = UserPresenter()
    fileprivate var defaultUniversityText = "No University Selected"
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var ivProfilePic: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var lblUnversity: UILabel!
    
    @IBAction func logOff(_ sender: Any) {
        NotificationCenter.default.post(Notification.notificationForLogOut())
    }
    
    @IBAction func onDoneTapped(_ sender: Any) {
        guard var userProfile = record else { return }
        
        //map fields to values
        userProfile.email = self.lblUsername.text
        userProfile.address = self.tfAddress.text
        userProfile.name = self.tfName.text
        userProfile.university = (self.lblUnversity.text != defaultUniversityText) ? self.lblUnversity.text : ""
        
        if let imageVal = self.ivProfilePic?.image, let imageData = imageVal.jpegData(compressionQuality: 0.75) {
            userProfile.imageData = imageData
        }
        
        self.userPresenter.setRecordForCurrentUser(userProfile) { [weak self](error) in
            guard let `self` = self else {
                return
            }
            if error != nil {
                self.showAlertWithTitle(NSLocalizedString("Error!", comment: ""), message: (error?.localizedDescription) ?? "Failed to update user record")
            }
            else {
                 self.showAlertWithTitle("", message: "Succesfully updated profile!")
            }
        }
    }
    
    @IBAction func onSelectUniversity(_ sender: Any) {
        if let destinationViewController = (self.storyboard?.instantiateViewController(withIdentifier: "UniversityViewController")) as? UniversityViewController {
            
            destinationViewController.modalPresentationStyle = .formSheet
            destinationViewController.onDoneBlock = onUniversitySelected
            
            if (self.lblUnversity.text != defaultUniversityText){
                destinationViewController.currUniversitySelection = self.lblUnversity?.text
            }
            self.present(destinationViewController, animated: true, completion: {})
        }
    }
    
    @IBAction func onUploadImage(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.modalPresentationStyle = .popover
        
        let albumAction = UIAlertAction(title: NSLocalizedString("Select From Photo Album", comment: ""), style: .default) { action in
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary;
            
            imagePickerController.modalPresentationStyle = .overCurrentContext
            
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.camera) {
            let cameraAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .default) { [unowned self] action in
                
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.allowsEditing = false
                imagePickerController.sourceType = UIImagePickerController.SourceType.camera;
                imagePickerController.cameraDevice = UIImagePickerController.CameraDevice.front;
                
                imagePickerController.modalPresentationStyle = .overCurrentContext
                
                self.present(imagePickerController, animated: true, completion: nil)
                
            }
            alert.addAction(cameraAction)
        }
        alert.addAction(albumAction)
        
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        present(alert, animated: true, completion: nil)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //set delegate to make return key dismiss keyboard
        //don't register this in setFields or it will run multple times
        //as setFields runs when the data is updated from the database from
        //tapping the Done button
        tfName.delegate = self
        tfAddress.delegate = self
        
        //setup presenter
        self.userPresenter.attachPresentingView(self)
        self.userPresenter.fetchRecordForCurrentUserWithLiveModeEnabled(__: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tfName.text = ""
        tfAddress.text = ""
        lblUsername.text = ""
        lblUnversity.text = defaultUniversityText
        ivProfilePic.image = UIImage.init(imageLiteralResourceName: "default-user-thumbnail")
        self.userPresenter.detachPresentingView(self)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        //dismiss keyboard if you click anywhere else in the view
        //useful if they don't know how to use the return key on the keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        doneButton.isEnabled = true
        view.endEditing(true)
    }
    
    public func onUniversitySelected(_ university:String?) {
        print ("University \(String(describing: university)) selected")
        self.lblUnversity.text = university
        self.doneButton.isEnabled = true
    }
    
    //presenter protocol call to update the data on the screen
    func updateUIWithUserRecord(_ record: UserRecord?, error: Error?) {
        switch error {
        case nil:
            self.record = record
            self.setFields()
        default:
            self.showAlertWithTitle(NSLocalizedString("Error!", comment: ""), message: (error?.localizedDescription) ?? "Failed to fetch date user record")
        }
    }
    
    //maps data from DAO to fields on View Controller
    func setFields(){
        tfName.text = record?.name
        tfAddress.text = record?.address
        lblUsername.text = record?.email
        if (record?.university != "" && record?.university != nil){
            lblUnversity.text = record?.university
        }
        
        if let imageData = self.record?.imageData {
            ivProfilePic.image = UIImage.init(data: imageData)
        } else {
            ivProfilePic.image = UIImage.init(imageLiteralResourceName: "default-user-thumbnail")
        }
    }
}

//MARK: UIImagePicker extension methods
extension ProfileViewController
    : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            self.ivProfilePic.image = image
            self.imageUpdated = true
            self.doneButton.isEnabled = true

            picker.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

//MARK: TextField Delegate method
extension ProfileViewController : UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        textField.resignFirstResponder()
        self.doneButton.isEnabled = true
        return true
    }
}
