//
//  MessageTVCell.swift
//  SysmindAssignment
//
//  Created by Ganpat Jangir on 01/05/25.
//

import UIKit

class MessageTVCell: UITableViewCell {
    
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var messageLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.labelView.layer.cornerRadius = 16.0
        self.labelView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner,
            .layerMinXMaxYCorner
        ]
        self.labelView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(message: String) {
        self.messageLbl.text = message.replacingOccurrences(of: "\n", with: "")
    }
    
}
