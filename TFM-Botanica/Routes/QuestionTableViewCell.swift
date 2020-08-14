//
//  QuestionTableViewCell.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 12/05/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit
import iOSDropDown

class QuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var answerDropDown: DropDown!
    
    var trueAnswer: String = ""
    var isCorrected: Bool = false
    var lastAnswer: String = ""
    
    override func layoutSubviews() {
        self.cardView.layer.cornerRadius = 8
        
        let shadowRect = CGRect(x: 0, y: 0, width: self.cardView.bounds.width, height: self.cardView.bounds.height)
        self.cardView.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        self.cardView.layer.shadowRadius = 5
        self.cardView.layer.shadowOffset = .zero
        self.cardView.layer.shadowOpacity = 1
        self.cardView.layer.shadowColor = UIColor.black.cgColor
        self.cardView.layer.shouldRasterize = true
        self.cardView.layer.rasterizationScale = UIScreen.main.scale
        
        self.titleLable.adjustsFontSizeToFitWidth = true
        
        self.answerDropDown.adjustsFontSizeToFitWidth = true
    }
    
    func checkTrueAnswer() {
        self.answerDropDown.hideOptionsWhenSelect = true
        self.answerDropDown.didSelect{(selectedText , index ,id) in
            if(selectedText == self.trueAnswer) {
                self.isCorrected = true
            } else {
                self.isCorrected = false
            }

            if self.lastAnswer != selectedText {
                self.answerDropDown.checkMarkEnabled = false
                self.answerDropDown.selectedRowColor = UIColor.green
                self.answerDropDown.backgroundColor = UIColor.white
                self.lastAnswer = selectedText
            }
        }
    }
    
    func changeColor() {
        var color: UIColor = UIColor.clear
        if self.isCorrected == true {
            self.answerDropDown.checkMarkEnabled = true
            self.answerDropDown.selectedRowColor = UIColor.green
            color = UIColor.green
        } else {
            self.answerDropDown.checkMarkEnabled = false
            self.answerDropDown.selectedRowColor = UIColor.init(red: 1, green: 0.2, blue: 0.2, alpha: 1)
            color = UIColor.init(red: 1, green: 0.2, blue: 0.2, alpha: 1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.answerDropDown.backgroundColor = color
        }
    }
}
