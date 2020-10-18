//
//  CustomUITextView.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 15/10/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
    func adjustUITextViewHeight()
    {
        translatesAutoresizingMaskIntoConstraints = true
        sizeToFit()
        isScrollEnabled = false
    }
}
