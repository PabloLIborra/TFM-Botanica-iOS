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

class JSONRequest{
    static let url = "http://jtech.ua.es/uaplant/"
    
    static var downloadRoutes = 0
    
    static var totalImagesDownload = 0
    static var downloadedImges = 0
    static var removedSpinner: Bool = false
    
    static var imagesLocalizationToDownload = [Activity: String]()
    static var imagesPlantsToDownload = [Plant: [String]]()
    
    static func readJSONFromServer(view: UIViewController) {

        downloadRoutes = 0
        totalImagesDownload = 0
        downloadedImges = 0
        removedSpinner = false
        imagesLocalizationToDownload.removeAll()
        imagesPlantsToDownload.removeAll()
        
        view.showSpinner(onView: view.view, textLabel: "Descargando archivos")

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
                                                    downloadRoutes += 1
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
                                                                imagesLocalizationToDownload[activityData!] = nameFolder + "/" + nameLocationImage!
                                                                
                                                                let plantData = NSEntityDescription.insertNewObject(forEntityName: "Plant", into: miContexto) as? Plant
                                                                plantData?.scientific_name = plant["nombre_cientifico"] as? String
                                                                plantData?.family = plant["familia"] as? String
                                                                plantData?.information = plant["descripcion_planta"] as? String
                                                                plantData?.unlock = false
                                                                plantData?.activity = activityData
                                                                activityData?.plant = plantData
                                                                
                                                                let images = plant["fotos_carrusel"] as? String
                                                                let splitImages = images!.components(separatedBy: ";")

                                                                var listImagePlants = imagesPlantsToDownload[plantData!] ?? []
                                                                for namePlantImage in splitImages {
                                                                    listImagePlants.append(nameFolder + "/" + namePlantImage)
                                                                }
                                                                imagesPlantsToDownload[plantData!] = listImagePlants
                                                                
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
                                                    downloadRoutes += 1
                                                    if downloadRoutes >= splitFolders.count - 1{
                                                        removeSpinner(view: view)
                                                    }
                                                    print(route + " already exist")
                                                }
                                                if downloadRoutes >= splitFolders.count - 1 && removedSpinner == false {
                                                    for (_, values) in imagesPlantsToDownload {
                                                        for _ in values {
                                                            totalImagesDownload += 1
                                                        }
                                                    }
                                                    print(imagesLocalizationToDownload.count)
//                                                    view.changeLabelSpinner(text: "Descargando archivos " + String(downloadedImges) + "/" + String(totalImagesDownload + imagesLocalizationToDownload.count))
                                                    downloadImagesLocalization(miContexto: miContexto, view: view)
                                                    downloadImagesPlants(miContexto: miContexto, view: view)
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
    
    static func downloadImagesLocalization(miContexto: NSManagedObjectContext, view: UIViewController) {
        for (activityData, urlImage) in imagesLocalizationToDownload {
            if let urlImage: URL = URL(string: self.url + urlImage) {
                URLSession.shared.dataTask(with: urlImage) { data, response, error in
                    guard
                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                        let data = data, error == nil,
                        let image = UIImage(data: data)
                        else {
                            downloadedImges += 1
                            view.changeLabelSpinner(text: "Descargando archivos " + String(downloadedImges) + "/" + String(totalImagesDownload + imagesLocalizationToDownload.count))
                            removeSpinner(view: view)
                            return
                        }
                    DispatchQueue.main.async() {
                        let imageActivityData = NSEntityDescription.insertNewObject(forEntityName: "Image", into: miContexto) as? Image
                        imageActivityData?.image = image.pngData()
                        imageActivityData?.date = Date()
                        activityData.image = imageActivityData
                        downloadedImges += 1
                        view.changeLabelSpinner(text: "Descargando archivos " + String(downloadedImges) + "/" + String(totalImagesDownload + imagesLocalizationToDownload.count))
                        removeSpinner(view: view)
                        print("Descargada foto actividad")
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    }
                }.resume()
            }
        }
    }
    
    static func downloadImagesPlants(miContexto: NSManagedObjectContext, view: UIViewController) {
        for (plantData, urlsImages) in imagesPlantsToDownload {
            for urlImage in urlsImages {
                if let urlImage: URL = URL(string: self.url + urlImage) {
                    URLSession.shared.dataTask(with: urlImage) { data, response, error in
                        guard
                            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                            let data = data, error == nil,
                            let image = UIImage(data: data)
                            else {
                                downloadedImges += 1
                                view.changeLabelSpinner(text: "Descargando archivos " + String(downloadedImges) + "/" + String(totalImagesDownload + imagesLocalizationToDownload.count))
                                removeSpinner(view: view)
                                return
                            }
                        DispatchQueue.main.async() {
                            let imagePlantData = NSEntityDescription.insertNewObject(forEntityName: "Image", into: miContexto) as? Image
                            imagePlantData?.image = image.pngData()
                            imagePlantData?.date = Date()
                            plantData.addToImages(imagePlantData!)
                            print("Descargada foto planta")
                            downloadedImges += 1
                            view.changeLabelSpinner(text: "Descargando archivos " + String(downloadedImges) + "/" + String(totalImagesDownload + imagesLocalizationToDownload.count))
                            removeSpinner(view: view)
                            (UIApplication.shared.delegate as! AppDelegate).saveContext()
                        }
                    }.resume()
                }
            }
        }
    }
    
    static func removeSpinner(view: UIViewController) {
        if downloadedImges >= (totalImagesDownload + imagesLocalizationToDownload.count){
            view.removeSpinner()
            removedSpinner = true
            if let tableView = view as? RouteTableViewController {
                tableView.updateData()
                tableView.endRefreshing()
            }
        }
    }
}
