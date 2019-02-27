//
//  ViewController.swift
//  SwiftFirebaseBasic
//
//  Created by Naoki Arakawa on 2019/02/26.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit
import LineSDK

class ViewController: UIViewController, LineSDKLoginDelegate {
    
    var displayName = String()
    var pictureURL = String()
    var pictureURLString = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
   
        LineSDKLogin.sharedInstance().delegate = self
 
    }
    
    //表示名、プロフィール名、プロフィール画像を取ってきて、アプリケーション内に保存するということを行う
    //取得してきたデータはprofileに格納される
    func didLogin(_ login: LineSDKLogin, credential: LineSDKCredential?, profile: LineSDKProfile?, error: Error?) {
        
        //名前を取ってくる
        if let displayName = profile?.displayName {
            
            //self.displayNameはvar displayName = String()
            //=displayNameはprofile?.displayNameのdisplayName
            self.displayName = displayName
            
        }
        
        //画像を取ってくる
        if let pictureURL = profile?.pictureURL {
            
            //NSURL型をString型に変えたいときに、absoluteStringを使用する
            self.pictureURLString = pictureURL.absoluteString
            
        }
            
        //ユーザーデフォルトに保存する
        UserDefaults.standard.set(self.displayName, forKey: "displayName")
        UserDefaults.standard.set(self.pictureURLString, forKey: "pictureURLString")
        
        
        performSegue(withIdentifier: "next", sender: nil)
        
    }
    
    //ログインした時にログインの許可画面を開く
    @IBAction func login(_ sender: Any) {
        
        LineSDKLogin.sharedInstance().start()
        
        
        
    }
    

}
