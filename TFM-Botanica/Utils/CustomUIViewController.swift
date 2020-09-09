//
//  CustomUIViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 02/09/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import Foundation
import UIKit

var spinner : UIView?

extension UIViewController {
    func showSpinner(onView: UIView, textLabel: String) {
        
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
        
        DispatchQueue.main.async {
            spinnerView.addSubview(label)
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        spinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            spinner?.removeFromSuperview()
            spinner = nil
        }
    }
}
