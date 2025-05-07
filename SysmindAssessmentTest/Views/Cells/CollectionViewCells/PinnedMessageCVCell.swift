//
//  PinnedMessageCVCell.swift
//  SysmindAssignment
//
//  Created by Ganpat Jangir on 02/05/25.
//

import UIKit

class PinnedMessageCVCell: UICollectionViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(msg: String) {
        self.messageLabel.text = msg.replacingOccurrences(of: "\n", with: "")
    }

}
