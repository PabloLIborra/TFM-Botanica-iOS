//
//  InitViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 31/03/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit
import CoreData

var spinner : UIView?

class InitViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var initButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initButton.layer.cornerRadius = 8
        self.initButton.layer.borderWidth = 1
        self.initButton.layer.borderColor = UIColor.black.cgColor
        self.initButton.layer.backgroundColor = UIColor.init(red: 190/255, green: 255/255, blue: 208/255, alpha: 1.0).cgColor
        self.initButton.setTitleColor(UIColor.black, for: .normal)
        
        self.backgroundImage.image = UIImage(named: "background-init.jpg")
        self.backgroundImage.contentMode = .scaleAspectFill
        self.backgroundImage.alpha = 0.3
        
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        nameLabel.layer.shadowRadius = 5.0
        nameLabel.layer.shadowOpacity = 1.0
        nameLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
        nameLabel.layer.masksToBounds = false
        
        JSONRequest.readJSONFromServer(view: self)
    }
}

extension UIViewController {
    
    func showSpinner(onView: UIView, textLabel: String) {
        DispatchQueue.main.async {
            let spinnerView = UIView.init(frame: onView.bounds)
            spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: onView.bounds.width, height: 21))
            label.center = CGPoint(x: spinnerView.bounds.width/2, y: 2*spinnerView.bounds.height/5)
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
            label.text = textLabel
            
            let ai = UIActivityIndicatorView.init(style: .large)
            ai.color = UIColor.black
            ai.startAnimating()
            ai.center = spinnerView.center
            
            spinnerView.addSubview(label)
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
            spinner = spinnerView
        }
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            spinner?.removeFromSuperview()
            spinner = nil
        }
    }
    
    func changeLabelSpinner(text: String) {
        if spinner != nil {
            let labels = spinner?.subviews.filter{$0 is UILabel}
            let label: UILabel = labels![0] as! UILabel
            label.text = text
        }
    }
}
