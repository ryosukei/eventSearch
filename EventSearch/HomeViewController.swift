//
//  HomeViewController.swift
//  EventSearch
//
//  Created by 青野　凌介 on 2021/10/26.
//

import UIKit
import Firebase

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var floatingActionBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    // Firestoreのリスナー
    var listener: ListenerRegistration?
    
    
    @IBAction func handleFloatingActionBtn(_ sender: Any) {
    }
    
    var eventArray: [EventData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // buttonを角丸にする
        floatingActionBtn.layer.cornerRadius = 32
        tableView.delegate = self
        tableView.dataSource = self
        // カスタムセルを登録する
        let nib = UINib(nibName: "EventTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        // ログイン済みか確認
        if Auth.auth().currentUser != nil{
            let eventRef = Firestore.firestore().collection("events")
            listener = eventRef.addSnapshotListener(){ (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }
                // 取得したdataを配列に格納する
                self.eventArray = querySnapshot!.documents.map { document in
                    print("DEBUG_PRINT: document取得 \(document.documentID)")
                    let eventData = EventData(document: document)
                    return eventData
                }
                // TableViewの表示を更新する
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewWillDisappear")
        // listenerを削除して監視を停止する
        listener?.remove()
    }
    //    TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 550
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventTableViewCell
        cell.setEventData(eventArray[indexPath.row])
        // セル内のボタンのアクションをソースコードで設定する
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
        return cell
    }
    
    @objc func handleButton(_ sender: UIButton,forEvent event: UIEvent){
        print("DEBUG_PRINT: likeボタンがタップされました。")
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        // 配列からタップされたインデックスのデータを取り出す
        let eventData = eventArray[indexPath!.row]

        // likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            // 更新データを作成する
            var updateValue: FieldValue
            if eventData.isLiked {
                // すでにいいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                // 今回新たにいいねを押した場合は、myidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            // likesに更新データを書き込む
            let eventRef = Firestore.firestore().collection("events").document(eventData.id)
            eventRef.updateData(["likes": updateValue])
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
