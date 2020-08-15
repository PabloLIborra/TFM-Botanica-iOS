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
            route3.name = "Ruta Pinooooooooooooooos"
            route3.information = "Ruta destinada a los Pinoooooooooooooos."
            route3.state = Int16(State.AVAILABLE)
            
            let activity = Activity(context: miContexto)
            activity.latitude = 38.385750
            activity.longitude = -0.514250
            activity.title = "Universidad de Alicanteeeeeeeeeeeeeeeeeeee"
            activity.subtitle = "Alicanteeeeeeeeeeeeeeeeeeeeeee"
            activity.state = Int16(State.INACTIVE)
            activity.date = Date()
            activity.information = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
            activity.route = route3
            route3.addToActivities(activity)
            
            let plant = Plant(context: miContexto)
            plant.scientific_name = "Glanta de pruebaaaaaaaaaaaaaaa"
            plant.family = "Familia de pruebaaaaaaaaaaaaaaaaaaa"
            plant.information = "Planta de prueba, aqui solo voy a escribir informacion de prueba"
            plant.unlock = false
            plant.activity = activity
            activity.plant = plant
   
            let question = Question(context: miContexto)
            question.title = "¿Cómo me llamoooooooooooooooooooo?"
            question.date = Date()
            plant.addToQuestions(question)
            
            let answer = Answer(context: miContexto)
            answer.title = "Pablo"
            let answer2 = Answer(context: miContexto)
            answer2.title = "Pedroooooooooooooooooooooooooooo"
            
            question.true_answer = answer
            question.addToAnswers(answer)
            question.addToAnswers(answer2)
            
            let question2 = Question(context: miContexto)
            question2.title = "¿Cómo te llamas?"
            question2.date = Date()
            plant.addToQuestions(question2)
            
            let answer3 = Answer(context: miContexto)
            answer3.title = "Julian"
            let answer4 = Answer(context: miContexto)
            answer4.title = "Federico"
            
            question2.true_answer = answer3
            question2.addToAnswers(answer3)
            question2.addToAnswers(answer4)
            
            let question3 = Question(context: miContexto)
            question3.title = "¿Cómo te apellidas?"
            question3.date = Date()
            plant.addToQuestions(question3)
            
            let answer5 = Answer(context: miContexto)
            answer5.title = "Lopez"
            let answer6 = Answer(context: miContexto)
            answer6.title = "Garcia"
            
            question3.true_answer = answer5
            question3.addToAnswers(answer5)
            question3.addToAnswers(answer6)
       
            let activity2 = Activity(context: miContexto)
            activity2.latitude = 38.383827
            activity2.longitude = -0.516452
            activity2.title = "Aulario 1"
            activity2.subtitle = "Aulario"
            activity2.date = Date()
            activity2.state = Int16(State.INACTIVE)
            activity2.information = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
            activity2.route = route3
            route3.addToActivities(activity2)
            
            let plant2 = Plant(context: miContexto)
            plant2.scientific_name = "Flanta de prueba2"
            plant2.family = "Familia de prueba2"
            plant2.information = "Planta de prueba2, aqui solo voy a escribir informacion de prueba"
            plant2.unlock = false
            plant2.activity = activity2
            activity2.plant = plant2

            let activity3 = Activity(context: miContexto)
            activity3.latitude = 38.387711
            activity3.longitude = -0.511912
            activity3.title = "Escuela Politécnica Superior"
            activity3.subtitle = "EPS"
            activity3.state = Int16(State.INACTIVE)
            activity3.date = Date()
            activity3.information = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
            activity3.route = route3
            route3.addToActivities(activity3)
            
            let plant3 = Plant(context: miContexto)
            plant3.scientific_name = "Alanta de Pino"
            plant3.family = "Familia de pino"
            plant3.information = "Planta de pino, aqui solo voy a escribir informacion de prueba"
            plant3.unlock = false
            plant3.activity = activity3
            activity3.plant = plant3
            
            let activity5 = Activity(context: miContexto)
            activity5.latitude = 38.388789
            activity5.longitude = -0.515486
            activity5.title = "Gimasio"
            activity5.subtitle = "GYM"
            activity5.state = Int16(State.INACTIVE)
            activity5.date = Date()
            activity5.information = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
            activity5.route = route3
            route3.addToActivities(activity5)
            
            let plant4 = Plant(context: miContexto)
            plant4.scientific_name = "Mlanta de Hibisco"
            plant4.family = "Familia de Hibisco"
            plant4.information = "Planta de Hibisco, aqui solo voy a escribir informacion de prueba"
            plant4.unlock = false
            plant4.activity = activity5
            activity5.plant = plant4

            /*
            let route2 = Route(context:miContexto)
            route2.name = "Ruta Palmeras"
            route2.information = "Ruta destinada a la vista de Palmeras. Podremos ver los diferentes tipos. Cada actividad de esta sección esta compuesta por unas preguntas de prueba."
            route2.state = Int16(State.IN_PROGRESS)
            
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
 
 */
            
            do {
               try miContexto.save()
            } catch {
               print("Error al guardar el contexto: \(error)")
            }
        }
    }
}
