//
//  CheckListTableViewCell.swift
//  WSR-Asia
//
//  Created by ali on 8/5/21.
//

import UIKit

class CheckListTableViewCell: UITableViewCell {

    @IBOutlet weak var itemCheckBox: UIButton!
    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemCheckBox.setImage(UIImage(named: "selectedCheckbox")!, for: .selected)
        itemCheckBox.setImage(UIImage(named: "unSelectedCheckbox")!, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
