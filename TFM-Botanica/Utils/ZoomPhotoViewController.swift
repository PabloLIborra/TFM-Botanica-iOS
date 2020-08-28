//
//  ZoomPhotoViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 17/08/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit

class ZoomPhotoViewController: UIViewController {

    @IBOutlet weak var photoImage: UIImageView!
    var photo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.photoImage.image = self.photo?.withRoundedCorners(radius: 10)
        self.photoImage.isUserInteractionEnabled = true

        //Gesture close zoom photo
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        self.photoImage.isUserInteractionEnabled = true
        self.photoImage.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func imageTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    static func showZoomPhotoViewController(view: UIViewController, photo: UIImage, imageLoaded: Bool) {
        if imageLoaded == true {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let zoomPhotoController = storyboard.instantiateViewController(withIdentifier: "zoomPhotoController") as! ZoomPhotoViewController
            zoomPhotoController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            zoomPhotoController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
            var image = photo
            
            let widthInPixels = image.size.width * image.scale
            let heightInPixels = image.size.height * image.scale
            if widthInPixels / heightInPixels > 1.0 {
                image = image.rotate(radians: Float.pi / 2)!
            }
            
            zoomPhotoController.photo = image
            
            view.present(zoomPhotoController, animated: true, completion: nil)
        }
    }
}
