//
//  UIImageView+Extensions.swift
//  Breaking Bad
//
//  Created by Mehmet Ali Kısacık on 2.10.2022.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {

    func setImageWithPath(imageURLString: String?) {
        if let imageURLString = imageURLString {
            let processor = DownsamplingImageProcessor(size: self.frame.size )
            self.kf.setImage(with: URL(string: imageURLString ), options: [.processor(processor),.scaleFactor(UIScreen.main.scale),.transition(.fade(0.3)),.cacheOriginalImage]) { result in
                switch result{
                case .success(_):
                    break
                case .failure(_):
                    self.image = UIImage(systemName: "questionmark")?.withTintColor(.black,renderingMode: .alwaysOriginal)
                }
            }
        }
    }

}

