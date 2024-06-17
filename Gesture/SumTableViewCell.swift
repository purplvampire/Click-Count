//
//  SumTableViewCell.swift
//  Gesture
//
//  Created by 陳信彰 on 2024/6/16.
//

import UIKit

class SumTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var tapeCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
