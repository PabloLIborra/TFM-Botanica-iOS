//
//  InitViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 31/03/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit
import CoreData

class InitViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var initButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initButton.layer.cornerRadius = 8
        self.initButton.layer.borderWidth = 1
        self.initButton.layer.borderColor = UIColor.black.cgColor
        self.initButton.layer.backgroundColor = UIColor.systemBlue.cgColor
        self.initButton.setTitleColor(UIColor.white, for: .normal)
        
        loadExampleRoutes()
    }
    
    func loadExampleRoutes() {
        guard let miDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let miContexto = miDelegate.persistentContainer.viewContext
        
        let requestRoutes : NSFetchRequest<Route> = NSFetchRequest(entityName:"Route")
        let routes = try? miContexto.fetch(requestRoutes)
        
        if(routes?.count == 0) {
            
            let route3 = Route(context:miContexto)
            route3.name = "Ruta Pinos"
            route3.information = "Ruta destinada a los Pinos."
            route3.state = Int16(State.COMPLETE)
            
            let activity = Activity(context: miContexto)
            activity.latitude = 38.385750
            activity.longitude = -0.514250
            activity.title = "Universidad de Alicante"
            activity.subtitle = "Alicante"
            activity.state = Int16(State.INACTIVE)
            activity.information = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
            activity.route = route3
            route3.addToActivities(activity)
            
            let activity2 = Activity(context: miContexto)
            activity2.latitude = 38.383827
            activity2.longitude = -0.516452
            activity2.title = "Aulario 1"
            activity2.subtitle = "Aulario"
            activity2.state = Int16(State.ON_PROGRESS)
            activity2.information = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
            activity2.route = route3
            route3.addToActivities(activity2)
            
            let activity3 = Activity(context: miContexto)
            activity3.latitude = 38.387711
            activity3.longitude = -0.511912
            activity3.title = "Escuela Politécnica Superior"
            activity3.subtitle = "EPS"
            activity3.state = Int16(State.COMPLETE)
            activity3.information = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
            activity3.route = route3
            route3.addToActivities(activity3)
            
            let route2 = Route(context:miContexto)
            route2.name = "Ruta Palmeras"
            route2.information = "Ruta destinada a la vista de Palmeras. Podremos ver los diferentes tipos."
            route2.state = Int16(State.ON_PROGRESS)
            
            let activity4 = Activity(context: miContexto)
            activity4.latitude = 38.383827
            activity4.longitude = -0.516452
            activity4.title = "Aulario 1"
            activity4.subtitle = "Aulario"
            activity4.state = Int16(State.COMPLETE)
            activity4.information = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
            activity4.route = route2
            route2.addToActivities(activity4)
            
            let route5 = Route(context:miContexto)
            route5.name = "Ruta Abeto"
            route5.information = "Ruta destinada a los Abetos."
            route5.state = Int16(State.COMPLETE)
            
            let route = Route(context:miContexto)
            route.name = "Ruta Hibiscos"
            route.information = "Ruta destinada a los Hibiscos. Podremos ver los diferentes tipos."
            route.state = Int16(State.AVAILABLE)
            
            let route4 = Route(context:miContexto)
            route4.name = "Ruta Cipres"
            route4.information = "Ruta destinada a los Cipreses."
            route4.state = Int16(State.COMPLETE)
            
            let route6 = Route(context:miContexto)
            route6.name = "Ruta Prueba"
            route6.information = "Ruta para pruebas."
            route6.state = Int16(State.AVAILABLE)
            
            let activity5 = Activity(context: miContexto)
            activity5.latitude = 38.388789
            activity5.longitude = -0.515486
            activity5.title = "Gimasio"
            activity5.subtitle = "GYM"
            activity5.state = Int16(State.AVAILABLE)
            activity5.information = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
            activity5.route = route6
            route6.addToActivities(activity5)
            
            do {
               try miContexto.save()
            } catch {
               print("Error al guardar el contexto: \(error)")
            }
        }
    }
}