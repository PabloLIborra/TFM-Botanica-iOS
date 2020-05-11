//
//  CustomMarker.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 13/04/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import Foundation
import GoogleMaps

struct State {
    //CONSTANTS: State of the marker
    public static let ON_PROGRESS = 0
    public static let AVAILABLE = 1
    public static let COMPLETE = 2
    public static let INACTIVE = 3
}

class CustomMarker: GMSMarker {
    
    var state:Int = -1
    
    init(state: Int) {
        super.init()
        
        self.state = state
        
        switch state {
            case State.ON_PROGRESS:
                self.icon = GMSMarker.markerImage(with: UIColor.red)
            case State.AVAILABLE:
                self.icon = GMSMarker.markerImage(with: UIColor.cyan)
            case State.COMPLETE:
                self.icon = GMSMarker.markerImage(with: UIColor.green)
            case State.INACTIVE:
                self.icon = GMSMarker.markerImage(with: UIColor.gray)
                self.isTappable = false
            default:
                break
        }
    }
    
    public func setState(state: Int) {
        self.state = state
        
        switch state {
            case State.ON_PROGRESS:
                self.icon = GMSMarker.markerImage(with: UIColor.red)
                self.isTappable = true
            case State.AVAILABLE:
                self.icon = GMSMarker.markerImage(with: UIColor.cyan)
                self.isTappable = true
            case State.COMPLETE:
                self.icon = GMSMarker.markerImage(with: UIColor.green)
                self.isTappable = true
            case State.INACTIVE:
                self.icon = GMSMarker.markerImage(with: UIColor.gray)
                self.isTappable = false
            default:
                break
        }
    }
}
