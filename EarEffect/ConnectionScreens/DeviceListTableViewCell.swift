//
//  DeviceListTableViewCell.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-12.
//

import UIKit

class DeviceListTableViewCell: UITableViewCell {
    @IBOutlet weak var deviceName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
    }

    func setData(name:String){
        self.deviceName.text = name
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
