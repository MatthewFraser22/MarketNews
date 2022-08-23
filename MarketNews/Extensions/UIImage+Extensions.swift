//
//  UIImage+Extensions.swift
//  MarketNews
//
//  Created by Matthew Fraser on 2022-08-19.
//

import Foundation
import UIKit

extension UIImage {
    static let placeHolderImage = UIImage(named: ImageName.placeholderImage.rawValue, in: .main, compatibleWith: nil)!

    private enum ImageName: String {
        case placeholderImage = "placeholder-image"
    }
}
