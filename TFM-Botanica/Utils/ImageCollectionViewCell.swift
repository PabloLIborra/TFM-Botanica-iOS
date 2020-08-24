//
//  ImageCollectionViewCell.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 18/08/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    var parentView: UIViewController?
    @IBOutlet weak var photoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Gesture zoom photo
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        self.photoImage.isUserInteractionEnabled = true
        self.photoImage.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func imageTapped()
    {
        ZoomPhotoViewController.showZoomPhotoViewController(view: self.parentView!, photo: self.photoImage.image!)
    }

}
