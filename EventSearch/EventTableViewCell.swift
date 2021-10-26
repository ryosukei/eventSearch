//
//  EventTableViewCell.swift
//  EventSearch
//
//  Created by 青野　凌介 on 2021/10/26.
//

import UIKit
import FirebaseStorageUI

class EventTableViewCell: UITableViewCell {


    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var placeTextView: UILabel!
    @IBOutlet weak var fromDateTextView: UILabel!
    @IBOutlet weak var toTextView: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setEventData(_ eventData: EventData){
        // 画像の表示
        eventImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child("images").child(eventData.image!)
        eventImageView.sd_setImage(with: imageRef)
        print("Debug 画像 \(imageRef)")
        // 名前を表示
        nameView.text = eventData.name
        // 場所を表示
        placeTextView.text = eventData.place
        
        // 開始日の日付を表示
        if let fromDate = eventData.fromDate, let toDate = eventData.toDate{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let fromDateString = formatter.string(from: fromDate)
            let toDateString = formatter.string(from: toDate)
            fromDateTextView.text = fromDateString
            toTextView.text = toDateString
        }
        // いいね数の表示
        let likeNumber = eventData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        // いいねボタンの表示
        if eventData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
    }
    
}
