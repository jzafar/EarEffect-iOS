//
//  ModelsTableViewCell.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-15.
//

import UIKit

class ModelsTableViewCell: UITableViewCell {
    @IBOutlet weak var deviceImage: UIImageView!
    @IBOutlet weak var lblDeviceName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func setData(device:Device){
        self.lblDeviceName.text = device.name
        self.deviceImage.image = UIImage(named: device.image) 
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
