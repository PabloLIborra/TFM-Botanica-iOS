//
//  ActivityViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 31/03/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stateImageColor: UIImageView!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    
    var imagePicker: UIImagePickerController! = UIImagePickerController()
    var cameraImage: UIImage! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.questionButton.layer.cornerRadius = 8
        self.questionButton.layer.borderWidth = 3
        self.questionButton.layer.borderColor = UIColor.black.cgColor
        self.questionButton.layer.backgroundColor = UIColor.systemBlue.cgColor
        self.questionButton.setTitleColor(UIColor.white, for: .normal)
        self.captureButton.layer.cornerRadius = 8
        self.captureButton.layer.borderWidth = 3
        self.captureButton.layer.borderColor = UIColor.black.cgColor
        self.captureButton.layer.backgroundColor = UIColor.systemBlue.cgColor
        self.captureButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func questionAction(_ sender: Any) {
    }
    
    @IBAction func captureAction(_ sender: Any) {
        self.imagePicker.sourceType = .camera
        self.imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(self.cameraImage != nil) {
            if(segue.destination is CameraViewController) {
                if(self.cameraImage != nil) {
                    let vc = segue.destination as? CameraViewController
                    vc?.imageFromCamera = self.cameraImage
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier == "cameraSegue") {
            return false
        }
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imagePicker.dismiss(animated: true, completion: nil)
        self.cameraImage = info[.originalImage] as? UIImage
        if(self.cameraImage != nil) {
            self.performSegue(withIdentifier: "cameraSegue", sender: nil)
        }
    }
    
}
