//
//  MemeTextFieldDelegate.swift
//  com.snehal.com-snehal-memeV1
//
//  Created by snehal on 26/07/18.
//  Copyright © 2018 Snehal. All rights reserved.
//

import Foundation
import UIKit


class MemeTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    var isDefault: Bool = true
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        if(isDefault){
            textField.text = ""
            isDefault = false
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}

