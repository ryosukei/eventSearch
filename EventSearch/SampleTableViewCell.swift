//
//  SampleTableViewCell.swift
//  EventSearch
//
//  Created by 青野　凌介 on 2021/10/26.
//

import UIKit

class SampleTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTextView: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setEventData(_ eventData: EventData){
        // 名前を表示
        nameTextView.text = eventData.name
        print("Debug テキスト \(nameTextView.text!)")
    }
    
}
