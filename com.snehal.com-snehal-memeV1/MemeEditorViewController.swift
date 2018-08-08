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
    //Mark: Subscribe to the keyboard Events and Camera option is been checked for the devices not having camera like Simulator
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
          self.subscribeToKeyboardNotifications()
        
      camerabutton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)


    }
    //Mark : Unsubscibe from the Keyboard Event
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    
    //Mark: This function let users enable to pick an image from the album or any videos
    //IMPOrtant : The sourcetype is .photoLibrary
    @IBAction func pickAnImageFromAlbum(_sender : Any){
        pickimage(source: .photoLibrary)
        
        
    }
    
    //Mark: This enables pickAnImage function power model and displays onto screen
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imagepicker.image = image
            self.textfeild1.delegate = self.toptextfeild
            self.textfeild2.delegate = self.bottomtextfeild
            
        }
        //Dismiss action when nothing is been selected
        dismiss(animated: true, completion: nil)
    }
    
    //Mark User can either press cancel button from pickingImage window itself
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
        

        
    }
    // Mark : The Text feild which is been defined above (i.e textfeild1 and textfeild2) focuses upon
    func textFieldDidBeginEditing(_ textField: UITextField) -> Bool{
        return textField.isEditing
        
    }
    //Mark: Return button action with keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //Mark: Pick image from camera
    //Important is sourceType = .camera
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickimage(source: .camera)
    }
    
    
    
    
    func pickimage(source : UIImagePickerControllerSourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = source
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    
    //Mark: Set Attributes of Text feild
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black, /* TODO: fill in appropriate UIColor */
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white /* TODO: fill in appropriate UIColor */,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -3.0 /* TODO: fill in appropriate Float */]
    
    
    
    //Mark: Keyboard invoke
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    // Mark : Keyboard invoke returning
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    //Mark: Function of KeyboardWillShow
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if (textfeild2.isFirstResponder) {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    
    //Mark : Get the Ket Boardheight
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    //Mark: tFunction will hide kyeboard
   @objc func KeyboardWillHide(_ notification:Notification)  {
        view.frame.origin.y = 0
    }
    
    //Mark GeneratMemeImage
    func generateMemedImage() -> UIImage {
        
        self.items.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    var meme = Meme()
    //Function to save the Meme
    func save() {
        // Create the meme
        let meme = Meme(textTop: textfeild1.text!, textBottom: textfeild2.text!, imageOriginal: imagepicker.image!, imageMemed: generateMemedImage())
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }

    //Mark: Function to invoke Share button option menu UIActivityView
    @IBAction func shareMeme(){
        
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) -> () in
            if (completed) {
                self.save()
                self.sharImagebutton.isEnabled = true
                self.dismiss(animated: true, completion: nil)
                self.save()
            }
        }
        
        present(controller, animated: true, completion: nil)
        
        
    }
    //Mark: Cancel Buton actions . Alret
    @IBAction func cancelEdit(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Do you really want to cancel editing?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
            }
        )
        
        alert.addAction(UIAlertAction(title: "Keep editing", style: .default) { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
            }
        )
        
        present(alert, animated: true, completion: nil)
    }
    
}

