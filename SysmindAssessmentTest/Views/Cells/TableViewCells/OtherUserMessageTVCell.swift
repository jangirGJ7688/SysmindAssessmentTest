//
//  OtherUserMessageTVCell.swift
//  SysmindAssignment
//
//  Created by Ganpat Jangir on 01/05/25.
//

import UIKit

class OtherUserMessageTVCell: UITableViewCell {
    
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var messageView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.messageView.layer.cornerRadius = 16.0
        self.messageView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner,
            .layerMaxXMaxYCorner
        ]
        self.messageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(message: String) {
        self.messageLbl.text = message.replacingOccurrences(of: "\n", with: "")
    }
    
}
