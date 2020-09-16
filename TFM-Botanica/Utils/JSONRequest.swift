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
    static let url = "http://jtech.ua.es/uaplant/"
    
    static func readJSONFromServer() {
        guard let miDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let miContexto = miDelegate.persistentContainer.viewContext
        
        if let urlIndex: URL = URL(string: self.url + "index.txt") {
            URLSession.shared.dataTask(with: urlIndex) { data, response, error in
                if error != nil {
                   print(error!)
                }
                else {
                    if let textFile = String(data: data!, encoding: .utf8) {
                        let splitFolders = textFile.components(separatedBy: "\n")
                        for nameFolder in splitFolders {
                            if let urlJSON: URL = URL(string: self.url + nameFolder + "/" + nameFolder + ".json") {
                                URLSession.shared.dataTask(with: urlJSON) { data, response, error in
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
                                                                
                                                                let nameLocationImage = plant["foto_localizacion"] as? String
                                                                if let urlImage: URL = URL(string: self.url + nameFolder + "/" + nameLocationImage!) {
                                                                    URLSession.shared.dataTask(with: urlImage) { data, response, error in
                                                                        guard
                                                                            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                                                                            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                                                                            let data = data, error == nil,
                                                                            let image = UIImage(data: data)
                                                                            else { return }
                                                                        DispatchQueue.main.async() {
                                                                            let imageActivityData = NSEntityDescription.insertNewObject(forEntityName: "Image", into: miContexto) as? Image
                                                                            imageActivityData?.image = image.pngData()
                                                                            imageActivityData?.date = Date()
                                                                            activityData?.image = imageActivityData
                                                                            print("Descargada foto actividad")
                                                                            (UIApplication.shared.delegate as! AppDelegate).saveContext()
                                                                        }
                                                                    }.resume()
                                                                }
                                                                
                                                                let plantData = NSEntityDescription.insertNewObject(forEntityName: "Plant", into: miContexto) as? Plant
                                                                plantData?.scientific_name = plant["nombre_cientifico"] as? String
                                                                plantData?.family = plant["familia"] as? String
                                                                plantData?.information = plant["descripcion_planta"] as? String
                                                                plantData?.unlock = false
                                                                plantData?.activity = activityData
                                                                activityData?.plant = plantData
                                                                
                                                                let images = plant["fotos_carrusel"] as? String
                                                                let splitImages = images!.components(separatedBy: ";")
                                                                
                                                                for namePlantImage in splitImages {
                                                                    if let urlImage: URL = URL(string: self.url + nameFolder + "/" + namePlantImage) {
                                                                        URLSession.shared.dataTask(with: urlImage) { data, response, error in
                                                                            guard
                                                                                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                                                                                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                                                                                let data = data, error == nil,
                                                                                let image = UIImage(data: data)
                                                                                else { return }
                                                                            DispatchQueue.main.async() {
                                                                                let imagePlantData = NSEntityDescription.insertNewObject(forEntityName: "Image", into: miContexto) as? Image
                                                                                imagePlantData?.image = image.pngData()
                                                                                imagePlantData?.date = Date()
                                                                                plantData?.addToImages(imagePlantData!)
                                                                                print("Descargada foto planta")
                                                                                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                                                                            }
                                                                        }.resume()
                                                                    }
                                                                }
                                                                
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
