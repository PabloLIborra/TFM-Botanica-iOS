//
//  SendQuestionTableViewCell.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 05/08/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit

class SendQuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var sendButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.sendButton.layer.cornerRadius = 8
        self.sendButton.layer.borderWidth = 1
        self.sendButton.layer.borderColor = UIColor.black.cgColor
        self.sendButton.layer.backgroundColor = UIColor.barColor.cgColor
        self.sendButton.setTitleColor(UIColor.black, for: .normal)
    }

}
