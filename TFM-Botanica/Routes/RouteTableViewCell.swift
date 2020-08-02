//
//  RouteTableViewCell.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 30/03/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cardView.layer.cornerRadius = 8
        
        let shadowRect = CGRect(x: 0, y: 0, width: self.cardView.bounds.width, height: self.cardView.bounds.height)
        self.cardView.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        self.cardView.layer.shadowRadius = 5
        self.cardView.layer.shadowOffset = .zero
        self.cardView.layer.shadowOpacity = 1
        self.cardView.layer.shadowColor = UIColor.black.cgColor
    }
}
