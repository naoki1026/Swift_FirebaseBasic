//
//  TimeLineViewController.swift
//  SwiftFirebaseBasic
//
//  Created by Naoki Arakawa on 2019/02/26.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

//データをFirebaseから受信する
//そのためFirebaseが必要になる

import UIKit
import Firebase

class TimeLineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    //受け取り用のdisplayNameを作る
    var displayName = String()
    var comment = String()
    
    @IBOutlet weak var tableView: UITableView!
    
    let refleshControl =  UIRefreshControl()
    
    var userName_Array = [String]()
    var comment_Array = [String]()
    
    //Postクラスが入る配列
    var posts = [Post]()
    
    //先ほど作成したクラスのPostを初期化している
    var posst = Post()


    override func viewDidLoad() {
        super.viewDidLoad()

        
         tableView.delegate = self
         tableView.dataSource = self
        
        refleshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        
        //#selector()の中に、引っ張った時の処理内容を記述する
        //＃はObjective-Cの記号であるため、入力した際にエラーが表示されてしまうので、FIXをクリックする
        refleshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    //画面が開くたびに呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        //データを取ってくる
        fetchPost()
        
        //テーブルビューをリロードする
        tableView.reloadData()
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        //ここはfirebaseから取ってくるため配列になる
        //配列の中に登録されている値分だけ、セクションの中のセルを作成する
        return posts.count
    }
    
    //セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //タグを使って、ラベルを特定する
        let userNameLabel = cell.viewWithTag(1) as! UILabel
        
        //indexPathの６番目のuserNameを取ってくる
        userNameLabel.text = self.posts[indexPath.row].userName
        
        
        //タグを使って、ラベルを特定する
        let commentLabel = cell.viewWithTag(2) as! UILabel
        
        //indexPathの６番目のuserNameを取ってくる
        commentLabel.text = self.posts[indexPath.row].comment
        
        //cellを返す
        return cell
        
    }
    
    //高さを決めていく
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //セルの高さをreturnの後に入力する
        return 115
        
    }
    
    //Objective-Cの記号により引用された場合に@objcとなる
    @objc func refresh() {
        
        //引っ張って更新された時に呼ばれる箇所
         fetchPost()
        
        //以下のようにしないとリロードが永遠に止まらなくなってしまう
        refleshControl.endRefreshing()
        
    }
    

    func fetchPost(){
        
       
        
        //初期化
        //元々中身が入ったままだと、セルが更新されるタイミングで、配列の数とセルの数が
        //合わなくなってしまうため
        self.userName_Array = [String]()
        
        self.comment_Array = [String]()
        self.posst = Post()
        
        
        //これでFirebaseを使うための準備をする
        let ref = Database.database().reference()
        
        //postの中にデータを入れていく
        //observeSingleEventはpostから取ってきてくださいということを表している
        //firbaseの公式サイトに行くと書いてある
        //データ取得開始
        ref.child("post").observeSingleEvent(of: .value) { (snap, error) in
            
            //全てのデータはpostSnaoの中に入ってくる
            //文字列の辞書型で入ってくるということを定義している
            let postSnap = snap.value as? [String: NSDictionary]
            
            if postSnap == nil {
                
                return
                
            }
            
            //初期化
            self.posts = [Post]()
            
            
            //postsnapの中にあるものをpostの中に取ってくる
            for (_,post) in postSnap! {
                
            //postクラスを初期化する
            self.posst = Post()
                
                //firebaseの中で、ここのコメントの書かれたところのテキストを
                //変数commentの中に入れてください
                //postSnapは文字型、なおかつ辞書型で保有しており、
                //postの中のcommentというキー値の中身をcommentの中に入れている
                if let comment = post["comment"] as? String, let userName = post["userName"] as? String {
                    
                    //postクラスの中にいったん入れている
                    self.posst.comment = comment
                    self.posst.userName = userName
                    
                    //配列にまとめている
                    self.comment_Array.append(self.posst.comment)
                    self.comment_Array.append(self.posst.userName)
                    
                }
                
                //配列としてまとめたものをposstの中に入れている
                self.posts.append(self.posst)
               
            }
            //これを行うことで正しく読み込まれることになる
            self.tableView.reloadData()
            
        }
       
    }

}


