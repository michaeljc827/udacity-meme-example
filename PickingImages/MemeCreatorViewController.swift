//
//  ViewController.swift
//  PickingImages
//
//  Created by Michael Chavez on 12/3/18.
//  Copyright © 2018 SDM. All rights reserved.
//

import UIKit
import Foundation

class MemeCreatorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate{
    
    //Used to determine which text field is being used. So we can move screen up if keyboard is hiding it
    var activeField: UITextField?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextLabel: UITextField!
    @IBOutlet weak var bottomTextLabel: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        //Disable Camera Button if no camera on device
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //Subscribe to keyboard notifications for better viewing of labels when typing
        subscribeToKeyboardNotifications()
        
        //Set default attributes for text labels
        self.setTextfieldAttributes(textfield: topTextLabel)
        self.setTextfieldAttributes(textfield: bottomTextLabel)
        
        //Set delegates for text labels
        self.topTextLabel.delegate = self
        self.bottomTextLabel.delegate = self
    }
    
    func setTextfieldAttributes(textfield field: UITextField) {
        let memeTextAttributes:[NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth : NSNumber(value: -2.0)
        ]
        
        field.defaultTextAttributes = memeTextAttributes
        field.textAlignment = NSTextAlignment.center
    }
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    //UIImagePicker Delegate Methods
    @IBAction func pickImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController,animated: true,completion: nil)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        present(pickerController,animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.shareButton.isEnabled = true
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //Keyboard Notification Methods
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(MemeCreatorViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeCreatorViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y -= getKeyboardHeightIfNeeded(notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeightIfNeeded(_ notification:Notification) -> CGFloat {
        if let _ = self.activeField {
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
            let textFieldYPosition = self.activeField!.frame.origin.y
            //If selected text field is covered by keyboard, move the view up by the size of the keyboard. Else don't move it at all
            if (keyboardSize.cgRectValue.height < textFieldYPosition){
                return keyboardSize.cgRectValue.height
            }
        }
        return 0
    }
    
    /*Text Label Delegate Methods. Sets active text field to avoid scrolling view when using keyboard on top label*/
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
        
        //Do not allow user to touch a different text field is one is being edited. This is to make sure keyboardWillShow is called everytime a new label is being edited.
        if (activeField != self.topTextLabel){
            self.topTextLabel.isEnabled = false;
        } else {
            self.bottomTextLabel.isEnabled = false;
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = nil
        self.topTextLabel.isEnabled = true;
        self.bottomTextLabel.isEnabled = true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    //Functions to save and share meme
    func save() {
        let memedImage = self.generateMemedImage()
        //Create the meme
        let meme = Meme(topText: self.topTextLabel.text!,bottomText: self.bottomTextLabel.text!,originalImage: self.imageView.image!,memedImage: memedImage)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    func generateMemedImage() -> UIImage {
        self.toolbar.isHidden = true
        self.topToolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        self.toolbar.isHidden = false
        self.topToolBar.isHidden = false
        
        return memedImage
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if (success == true){
                self.save()
            }
        }
        present(activityViewController,animated: true,completion: nil)
        
    }
}

//Dismiss keyboard when user touches outside text field while editing
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
