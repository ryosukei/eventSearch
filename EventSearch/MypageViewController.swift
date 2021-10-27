//
//  MypageViewController.swift
//  EventSearch
//
//  Created by 青野　凌介 on 2021/10/26.
//

import UIKit
import Firebase

class MypageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var userNameTextView: UILabel!
    @IBOutlet weak var eventTableView: UITableView!
    // Firestoreのリスナー
    var listener: ListenerRegistration?
    var eventArray: [EventData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.delegate = self
        eventTableView.dataSource = self
        let nib = UINib(nibName: "EventTableViewCell", bundle: nil)
        eventTableView.register(nib, forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        // ログイン済みか確認
        // 名前を取得
        let userId = Auth.auth().currentUser?.uid
        
        let userRef = Firestore.firestore().collection("users").document(userId!)
        
        userRef.getDocument{(document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                self.userNameTextView.text = dataDescription?["name"] as? String
            } else {
                print("Document does not exist")
            }
        }
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
                var tmpEventArray: [EventData] = []
                for i in 0..<self.eventArray.count {
                    if self.eventArray[i].isLiked{
                        tmpEventArray.append(self.eventArray[i])
                    }
                }
                self.eventArray = tmpEventArray
                // TableViewの表示を更新する
                self.eventTableView.reloadData()
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
        return cell
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
