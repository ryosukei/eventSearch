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
        return cell
    }
    
    // FAB
    var startingFrame: CGRect!
    var endingFrame: CGRect!
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        if(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size
                                            .height) && self.floatingActionBtn.isHidden){
            self.floatingActionBtn.isHidden = false
            self.floatingActionBtn.frame = startingFrame
            UIView.animate(withDuration: 1.0) {
              self.floatingActionBtn.frame = self.endingFrame
             }
        }
    }
    func configureSizes() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        startingFrame = CGRect(x: 0, y: screenHeight+100, width: screenWidth, height: 100)
        endingFrame = CGRect(x: 0, y: screenHeight-100, width: screenWidth, height: 100)
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
