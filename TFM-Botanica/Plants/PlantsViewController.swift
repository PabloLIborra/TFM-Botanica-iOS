//
//  PlantsViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 01/08/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit
import FlexiblePageControl

class PlantsViewController: UIViewController {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var viewPageControl: UIView!
    var images: [Image] = []
    var imagesLoaded: [UIImage] = []
    @IBOutlet weak var familyLabel: UILabel!
    var family: String = ""
    @IBOutlet weak var descriptionText: UITextView!
    var textDescription: String = ""
    
    var pageControl = FlexiblePageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        tlabel.text = self.title
        tlabel.textColor = UIColor.black
        tlabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .center
        self.navigationItem.titleView = tlabel
        
        self.pageControl = FlexiblePageControl(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.viewPageControl.frame.size.height))
        if self.images.count > 0 {
            self.pageControl.numberOfPages = self.images.count
        } else {
            self.pageControl.numberOfPages = 1
        }
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        self.viewPageControl.addSubview(self.pageControl)
        
        //self.photoImage.image = UIImage(named: photoName)?.withRoundedCorners(radius: 30)
        self.familyLabel.text = "Familia: \(family)"
        self.familyLabel.adjustsFontSizeToFitWidth = true
        self.descriptionText.text = textDescription
        
        self.updateInterface()
        
        if self.images[0].image != nil {
            self.imagesLoaded.append(UIImage(data: self.images[0].image!)!.withRoundedCorners(radius: 40)!)
        } else {
            self.imagesLoaded.append(UIImage(named: "notAvailable.png")!)
        }
        
        DispatchQueue.main.async {
            for i in (1...self.images.count - 1) {
                let image = self.images[i]
                if image.image != nil {
                    self.imagesLoaded.append(UIImage(data: image.image!)!.withRoundedCorners(radius: 40)!)
                } else {
                    self.imagesLoaded.append(UIImage(named: "notAvailable.png")!)
                }
            }
        }
    }
    
    // MARK: Functions
    func updateInterface() {
        //Create report button
        let reportButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(reportActionButton))
        reportButton.image = UIImage(systemName: "exclamationmark.triangle")
        self.navigationItem.rightBarButtonItems = [reportButton]
    }
    
    @objc func reportActionButton() {
        CustomReportAlertViewController.shared.showReportAlertViewController(view: self)
    }
}

extension PlantsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.images.count > 0 {
            return self.images.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionCell", for: indexPath) as? ImageCollectionViewCell
        
        cell?.parentView = self
        
        if self.imagesLoaded.count > 0 {
            cell?.photoImage.image = self.imagesLoaded[indexPath.row]
            cell?.imageLoaded = true
        } else {
            cell?.photoImage.image = UIImage(named: "notAvailable.png")
            cell?.imageLoaded = false
        }
        cell?.photoImage.clipsToBounds = true
        
        return cell!
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
    }
}

extension PlantsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
