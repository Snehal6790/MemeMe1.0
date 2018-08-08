//
//  MemeCollectionViewController.swift
//  com.snehal.com-snehal-memeV1
//
//  Created by snehal on 08/08/18.
//  Copyright © 2018 Snehal. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController : UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        let object = UIApplication.shared.delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
       return appDelegate.memes 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        // Grab the DetailVC from Storyboard
//        let cell =  self.storyboard!.instantiateViewController(withIdentifier: "MemeCollectionViewController ") as! MemeCollectionViewController
        
        //Populate view controller with data from the selected item
//        tabBarController.villain = allVillains[(indexPath as NSIndexPath).row]
        
        // Present the view controller using navigation
//        navigationController!.pushViewController(tabBarController, animated: true)
        
    }
}
