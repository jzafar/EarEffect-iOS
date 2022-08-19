//
//  AlbumCollectionViewCell.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-18.
//

import UIKit

import Kingfisher

class AlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    func setData(name: String, image: URL?){
        self.lblName.text = name
        imageView.kf.setImage(with: image, placeholder: UIImage(named: "placeholder"))


    }
}

class CollectionViewSectionHeader: UICollectionReusableView {
    @IBOutlet weak var sectionHeaderlabel: UILabel!
}
