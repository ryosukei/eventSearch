//
//  EventData.swift
//  EventSearch
//
//  Created by 青野　凌介 on 2021/10/26.
//

import UIKit
import Firebase

class EventData: NSObject {
    var id:String
    var name: String?
    var place: String?
    var fromDate: Date?
    var toDate: Date?
    var likes: [String] = []
    var image: String?
    var isLiked: Bool = false
    init(document: QueryDocumentSnapshot){
        self.id = document.documentID

        let eventDic = document.data()
        
        self.name = eventDic["name"] as? String
        self.image = eventDic["image"] as? String
        self.place = eventDic["place"] as? String
        let fromDate = eventDic["fromDate"] as? Timestamp
        self.fromDate = fromDate?.dateValue()
        
        let toDate = eventDic["toDate"] as? Timestamp
        self.toDate = toDate?.dateValue()

        if let likes = eventDic["likes"] as? [String] {
            self.likes = likes
        }
        if let myid = Auth.auth().currentUser?.uid {
            // likesの配列の中にmyidが含まれているかチェックすることで、自分がいいねを押しているかを判断
            if self.likes.firstIndex(of: myid) != nil {
                // myidがあれば、いいねを押していると認識する。
                self.isLiked = true
            }
        }
    }
}
