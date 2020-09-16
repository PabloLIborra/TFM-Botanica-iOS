//
//  CreditsTableViewCell.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 16/09/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit

class CreditsTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textView.layer.borderWidth = 2
        self.textView.layer.borderColor = UIColor.black.cgColor
    }
}
