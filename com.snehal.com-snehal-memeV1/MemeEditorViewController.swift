//
//  MemeEditorViewController.swift
//  com.snehal.com-snehal-memeV1
//
//  Created by snehal on 25/07/18.
//  Copyright © 2018 Snehal. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let toptextfeild = MemeTextFieldDelegate()
    let bottomtextfeild = MemeTextFieldDelegate()
    
    @IBOutlet weak var imagepicker : UIImageView!
    @IBOutlet weak var items : UIToolbar!
    @IBOutlet weak var textfeild1 : UITextField!
    @IBOutlet weak var textfeild2 : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.textfeild1.text = "TOP"
        self.textfeild2.text = "BOTTOM"
        self.textfeild1.delegate = self.toptextfeild
        textfeild1.defaultTextAttributes = memeTextAttributes
        self.textfeild2.delegate = self.bottomtextfeild
        textfeild2.defaultTextAttributes = memeTextAttributes
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.KeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
          self.subscribeToKeyboardNotifications()
        

//        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    
    
    @IBAction func pickAnImageFromAlbum(_sender : Any){
        let displayedimage = UIImagePickerController()
        displayedimage.delegate = self
        displayedimage.sourceType = .photoLibrary
        present(displayedimage,animated: true , completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imagepicker.image = image
            self.textfeild1.delegate = self.toptextfeild
            self.textfeild2.delegate = self.bottomtextfeild
            
        }

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
        

        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) -> Bool{
        return textfeild1.isEditing
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black, /* TODO: fill in appropriate UIColor */
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white /* TODO: fill in appropriate UIColor */,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -3.0 /* TODO: fill in appropriate Float */]
    
    
    
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
   @objc func KeyboardWillHide(_ notification:Notification)  {
//    if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
//        if self.view.frame.origin.y != 0{
//            self.view.frame.origin.y = 0
//            }
//        }
        view!.frame.origin.y = 0
    }
    
    
}

