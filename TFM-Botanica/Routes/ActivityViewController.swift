//
//  ActivityViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 31/03/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit
import CoreData

class ActivityViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var mapViewController: MapViewController?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stateImageColor: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var questionButton: UIButton!
    
    var imagePicker: UIImagePickerController! = UIImagePickerController()
    
    var imageLoaded = false
    
    var activity: Activity? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateInterface()
    }
    
    // MARK: Functions
    
    func updateInterface() {
        //Create report button
        let reportButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(reportActionButton))
        reportButton.image = UIImage(systemName: "exclamationmark.triangle")
        self.navigationItem.rightBarButtonItems = [reportButton]
        
        //Update button inteface
        self.startButton.layer.cornerRadius = 8
        self.startButton.layer.borderWidth = 1
        self.startButton.layer.borderColor = UIColor.black.cgColor
        self.startButton.layer.backgroundColor = UIColor.init(red: 190/255, green: 255/255, blue: 208/255, alpha: 1.0).cgColor
        self.startButton.setTitleColor(UIColor.black, for: .normal)
        
        self.questionButton.layer.cornerRadius = 8
        self.questionButton.layer.borderWidth = 1
        self.questionButton.layer.borderColor = UIColor.black.cgColor
        self.questionButton.layer.backgroundColor = UIColor.init(red: 190/255, green: 255/255, blue: 208/255, alpha: 1.0).cgColor
        self.questionButton.setTitleColor(UIColor.black, for: .normal)
        
        self.titleLabel.adjustsFontSizeToFitWidth = true
        
        //Update data inteface
        self.updateActivityState()
        self.titleLabel.text = self.activity?.title
        
        if let image = self.activity?.image?.image {
            self.photoImage.image = UIImage(data: (image))!.withRoundedCorners(radius: 40)
            self.imageLoaded = true
        } else {
            self.photoImage.image = UIImage(named: "notAvailable.png")
        }
        self.descriptionTextField.text = self.activity?.information
        
        //Gesture zoom photo
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        self.photoImage.isUserInteractionEnabled = true
        self.photoImage.addGestureRecognizer(tapGestureRecognizer)
        
        self.updateButtonState()
    }

    @objc func imageTapped()
    {
        ZoomPhotoViewController.showZoomPhotoViewController(view: self, photo: self.photoImage.image!, imageLoaded: self.imageLoaded)
    }
    
    func updateButtonState() {
        //Update button state
        switch self.activity?.state {
            case Int16(State.INACTIVE):
                break;
            case Int16(State.IN_PROGRESS):
                self.startButton.isEnabled = false
                self.startButton.alpha = 0.3
                self.questionButton.isEnabled = true
                self.questionButton.alpha = 1.0
            case Int16(State.COMPLETE):
                self.startButton.isEnabled = false
                self.startButton.alpha = 0.3
                self.questionButton.isEnabled = true
                self.questionButton.alpha = 1.0
            case Int16(State.AVAILABLE):
                self.startButton.isEnabled = true
                self.startButton.alpha = 1.0
                self.questionButton.isEnabled = false
                self.questionButton.alpha = 0.3
            default:
                break
        }
    }
    
    func updateActivityState() {
        switch self.activity?.state {
            case Int16(State.INACTIVE):
                self.stateImageColor.tintColor = UIColor.gray
                self.stateLabel.text = "Estado: Inactiva"
            case Int16(State.IN_PROGRESS):
                self.stateImageColor.tintColor = UIColor.red
                self.stateLabel.text = "Estado: En Proceso"
            case Int16(State.COMPLETE):
                self.stateImageColor.tintColor = UIColor.green
                self.stateLabel.text = "Estado: Completada"
            case Int16(State.AVAILABLE):
                self.stateImageColor.tintColor = UIColor.cyan
                self.stateLabel.text = "Estado: Disponible"
            default:
                self.stateImageColor.tintColor = UIColor.gray
                self.stateLabel.text = "Estado: Inactiva"
        }
    }
    
    @IBAction func startActionButton(_ sender: Any) {
        self.updateActivityStateFromCoreData(state: State.IN_PROGRESS)
        self.updateInterface()
    }
    
    func updateActivityStateFromCoreData(state: Int) {
        if(self.activity?.state != Int16(State.COMPLETE)) {
            guard let miDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let miContexto = miDelegate.persistentContainer.viewContext
            
            let requestRoutes : NSFetchRequest<Route> = NSFetchRequest(entityName:"Route")
            let routes = try? miContexto.fetch(requestRoutes)
            
            if(routes!.count > 0) {
                for route in routes! {
                    if(self.activity?.route == route) {
                        let activities = self.mapViewController?.activities
                        for activity in activities! {
                            if self.activity == activity {
                                activity.state = Int16(state)
                                self.activity? = activity

                                var updateRoute = false
                                if(route.state == State.AVAILABLE) {
                                    route.state = Int16(State.IN_PROGRESS)
                                    updateRoute = true
                                }
                                
                                if(route.state == State.IN_PROGRESS && activities![activities!.count - 1] != activity && state == State.COMPLETE) {
                                    self.mapViewController?.unlockNextActivityFromActivityChange(activity: activity)
                                    self.activity?.plant?.unlock = true
                                    break
                                } else if(route.state == State.IN_PROGRESS && activities![activities!.count - 1] == activity && state == State.COMPLETE) {
                                    route.state = Int16(State.COMPLETE)
                                    self.activity?.plant?.unlock = true
                                    updateRoute = true
                                } else if(route.state == State.IN_PROGRESS && state == State.IN_PROGRESS) {
                                    updateRoute = true
                                }
                                
                                if (updateRoute == true) {
                                    self.mapViewController?.route = route
                                    self.mapViewController?.updateFromActivityChange()
                                    break
                                }
                            }
                        }
                    }
                }

                do {
                    try miContexto.save()
                } catch let error as NSError  {
                    print("Error al guardar el contexto: \(error)")
                }
            }
        }
    }
    
    @objc func reportActionButton() {
        CustomReportAlertViewController.shared.showReportAlertViewController(view: self)
    }
    
    @IBAction func questionAction(_ sender: Any) {
        
    }
    
    func completedRoute() {
        self.updateActivityStateFromCoreData(state: State.COMPLETE)
        self.updateInterface()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "questionSegue" {
            let destiny = segue.destination as! QuestionTableViewController
            destiny.activityViewController = self
            destiny.plant = self.activity?.plant
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
}
