//
//  JSONRequest.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 25/08/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class JSONRequest {
    
    static let urlIndex = "https://raw.githubusercontent.com/PabloLIborra/TFM-Botanica-iOS/master/TFM-Botanica/JSON/index.txt?token=AHTLPJLOQBCOBYO5L6TIBB27JY5T6"
    static let urlJSON = "https://github.com/PabloLIborra/TFM-Botanica-iOS/tree/master/TFM-Botanica/JSON/"
    
    static func readJSONFromServer() {
        guard let miDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let miContexto = miDelegate.persistentContainer.viewContext
        
        if let urlIndex: URL = URL(string: self.urlIndex) {
            URLSession.shared.dataTask(with: urlIndex) { data, response, error in
                if error != nil {
                   print(error!)
                }
                else {
                    if let textFile = String(data: data!, encoding: .utf8) {
                        let splitText = textFile.components(separatedBy: "\n")
                        for text in splitText {
                            var prueba: String = self.urlJSON
                            if text == "prueba.json" {
                                prueba = "https://raw.githubusercontent.com/PabloLIborra/TFM-Botanica-iOS/master/TFM-Botanica/JSON/prueba.json?token=AHTLPJMJUGSKSFAAV7MVTIC7JZSV6"
                            } else if text == "prueb2.json" {
                                prueba = "https://raw.githubusercontent.com/PabloLIborra/TFM-Botanica-iOS/master/TFM-Botanica/JSON/prueb2.json?token=AHTLPJPXSKTMDILCUL4JLDK7JZSMG"
                            }
                            if let url: URL = URL(string: prueba) {
                                URLSession.shared.dataTask(with: url) { data, response, error in
                                    if let data = data {
                                        guard let jsonSerialize = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return }
                                        guard let json = jsonSerialize as? [String: Any] else { return }
                                        if let route = json["itinerario"] as? String {
                                            
                                            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Route")
                                            let predicateName = NSPredicate(format: "name == %@",route)
                                            fetchRequest.predicate = predicateName

                                            do {
                                                let results = try miContexto.fetch(fetchRequest)
                                                if results.count == 0 {
                                                    do {
                                                        let routeData = NSEntityDescription.insertNewObject(forEntityName: "Route", into: miContexto) as? Route
                                                        routeData?.name = route
                                                    
                                                        if let information = json["informacion_itinerario"] as? String {
                                                            routeData?.information = information
                                                        }
                                                        routeData?.state = Int16(State.AVAILABLE)

                                                        if let plants = json["plantas"] as? [[String:Any]] {
                                                            for plant in plants {
                                                                let activityData = NSEntityDescription.insertNewObject(forEntityName: "Activity", into: miContexto) as? Activity
                                                                activityData?.title = plant["titulo_actividad"] as? String
                                                                activityData?.subtitle = plant["subtitulo_actividad"] as? String
                                                                activityData?.state = Int16(State.INACTIVE)
                                                                activityData?.information = plant["informacion_actividad"] as? String
                                                                activityData?.date = Date()
                                                                activityData?.longitude = (plant["lng"] as! NSString).doubleValue
                                                                activityData?.latitude = (plant["lat"] as! NSString).doubleValue
                                                                activityData?.route = routeData
                                                                routeData?.addToActivities(activityData!)
                                                                
                                                                let plantData = NSEntityDescription.insertNewObject(forEntityName: "Plant", into: miContexto) as? Plant
                                                                plantData?.scientific_name = plant["nombre_cientifico"] as? String
                                                                plantData?.family = plant["familia"] as? String
                                                                plantData?.information = plant["descripcion_planta"] as? String
                                                                plantData?.unlock = false
                                                                plantData?.activity = activityData
                                                                activityData?.plant = plantData
                                                                
                                                                if let questions = plant["preguntas"] as? [[String:Any]] {
                                                                    for question in questions {
                                                                        let questionData = NSEntityDescription.insertNewObject(forEntityName: "Question", into: miContexto) as? Question
                                                                        questionData?.title = question["titulo_pregunta"] as? String
                                                                        questionData?.date = Date()
                                                                        plantData?.addToQuestions(questionData!)
                                                                        
                                                                        let trueAnswerData = NSEntityDescription.insertNewObject(forEntityName: "Answer", into: miContexto) as? Answer
                                                                        trueAnswerData?.title = question["respuestac"] as? String
                                                                        questionData?.true_answer = trueAnswerData
                                                                        questionData?.addToAnswers(trueAnswerData!)
                                                                        
                                                                        let answers = question["respuestas"] as? String
                                                                        let splitAnswers = answers?.components(separatedBy: ";")
                                                                        for splitAnswer in splitAnswers! {
                                                                            let answerData = NSEntityDescription.insertNewObject(forEntityName: "Answer", into: miContexto) as? Answer
                                                                            answerData?.title = splitAnswer
                                                                            questionData?.addToAnswers(answerData!)
                                                                        }
                                                                        
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        
                                                        try miContexto.save()
                                                        print(route + " has been saved")
                                                    } catch {
                                                        print(error)
                                                    }
                                                } else {
                                                    print(route + " already exist")
                                                }
                                            }
                                            catch let error {
                                                print(error.localizedDescription)
                                            }
                                        }
                                    }
                                }.resume()
                            }
                        }
                    }
                }
            }.resume()
        }
        
        
    }
}
