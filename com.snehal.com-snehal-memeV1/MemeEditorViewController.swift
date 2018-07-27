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
    @IBOutlet weak var camerabutton : UIBarButtonItem!
    @IBOutlet weak var pick : UIBarButtonItem!
    @IBOutlet weak var sharImagebutton : UIBarButtonItem!
    @IBOutlet weak var cancelbutton : UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.textfeild1.text = "TOP"
        self.textfeild2.text = "BOTTOM"
        self.textfeild1.delegate = self.toptextfeild
        textfeild1.defaultTextAttributes = memeTextAttributes
        self.textfeild2.delegate = self.bottomtextfeild
        textfeild2.defaultTextAttributes = memeTextAttributes
        self.sharImagebutton.isEnabled = false
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.KeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
          self.subscribeToKeyboardNotifications()
        
      camerabutton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)


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
        return textField.isEditing
        
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
        view.frame.origin.y = 0
    }
    
    
    func generateMemedImage() -> UIImage {
        
        self.items.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    
//    func save() {
//        // Create the meme
//        let meme = MemeEditorViewController(topText: textfeild1.text!, bottomText: textfeild2.text!, originalImage: imagepicker.image!, memedImage: generateMemedImage())
//    }

    
    @IBAction func shareMeme(){
        
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) -> () in
            if (completed) {
                self.generateMemedImage()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(controller, animated: true, completion: nil)
        
        
    }
    
}

