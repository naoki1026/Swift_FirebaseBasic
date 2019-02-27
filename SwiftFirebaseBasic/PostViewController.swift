//
//  PostViewController.swift
//  SwiftFirebaseBasic
//
//  Created by Naoki Arakawa on 2019/02/27.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class PostViewController: UIViewController {
    
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    //アプリ内からデータを引き出す作業が必要になるため、
    //その変数を作成する必要がある
    var displayName = String()
    var pictureURLString = String()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayName = UserDefaults.standard.object(forKey: "displayName") as! String
        
        pictureURLString = UserDefaults.standard.object(forKey: "pictureURLString") as! String
    
        
        nameLabel.text = displayName
        //String型からURL型に変換
        profileImageView.sd_setImage(with: URL(string: pictureURLString), completed: nil)
        
        //角を丸くする
        profileImageView.layer.cornerRadius = 8.0
        
        profileImageView.clipsToBounds = true
        
        
        
    }
    
    //この中にデータベースに飛ばすためのコードを書いていく
    @IBAction func post(_ sender: Any) {
        
        
        let rootRef = Database.database().reference(fromURL: "https://swiftfirebasebasic1.firebaseio.com/").child("post").childByAutoId()
        
        let feed = ["comment":textField.text,"userName":nameLabel.text] as [String:Any]
        
        rootRef.setValue(feed)
        dismiss(animated: true, completion: nil)
        
    }
    
}
