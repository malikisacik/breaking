//
//  CharactersCollectionViewCell.swift
//  Breaking Bad
//
//  Created by Mehmet Ali Kısacık on 30.09.2022.
//

import UIKit
import Kingfisher

class CharactersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        characterImageView.layer.cornerRadius = 10
    }

    func setup(character: Character) {
        if let characterName = character.name {
            characterNameLabel.text = characterName
        }

        if let characterImageURLString = character.img {
            let processor = DownsamplingImageProcessor(size: characterImageView.frame.size )
            characterImageView.kf.setImage(with: URL(string: characterImageURLString), options: [.processor(processor),.scaleFactor(UIScreen.main.scale),.transition(.fade(1)),.cacheOriginalImage] )
        }
    }

}
