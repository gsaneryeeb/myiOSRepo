//
//  PhotoCollectionViewCell.swift
//  VirtualTourist
//
//  Created by JasonZ on 2017-2-15.
//  Copyright © 2017 saneryee. All rights reserved.
//

import UIKit

// MARK: - PhotoCollectionViewCell

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var trashOverlay: UIView!
    
    override var isSelected: Bool {
        didSet{
            self.trashOverlay.isHidden = !isSelected
        }
    }
}
