//
//  CustomReportAlertViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 13/08/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit
import MessageUI

class CustomReportAlertViewController: UIViewController {

    @IBOutlet weak var alertBox: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reportText: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var nameController: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alertBox?.layer.backgroundColor = UIColor.barColor.cgColor
        self.alertBox?.layer.borderColor = UIColor.black.cgColor
        self.alertBox?.layer.borderWidth = 1
        self.alertBox?.layer.cornerRadius = 30
        
        
        self.reportText?.layer.backgroundColor = UIColor.barColor.cgColor
        self.reportText?.layer.borderColor = UIColor.black.cgColor
        self.reportText?.layer.borderWidth = 1
        self.reportText?.layer.cornerRadius = 15
        self.reportText?.layer.backgroundColor = UIColor.barColor.cgColor
        self.reportText.becomeFirstResponder()
        
        self.sendButton.layer.cornerRadius = 8
        self.sendButton.layer.borderWidth = 1
        self.sendButton.layer.borderColor = UIColor.black.cgColor
        self.sendButton.layer.backgroundColor = UIColor.greenCell.cgColor
        self.sendButton.setTitleColor(UIColor.white, for: .normal)
        
        self.closeButton.layer.cornerRadius = 8
        self.closeButton.layer.borderWidth = 1
        self.closeButton.layer.borderColor = UIColor.black.cgColor
        self.closeButton.layer.backgroundColor = UIColor.greenCell.cgColor
        self.closeButton.setTitleColor(UIColor.white, for: .normal)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func sendAction(_ sender: Any) {
        print(nameController + "\n")
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    static func showReportAlertViewController(view: UIViewController) {
        // Modify following variables with your text / recipient
        let recipientEmail = "test@email.com"
        let subject = "Multi client email support"
        let body = "This code supports sending email via multiple different email apps on iOS! :)"

        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)

            view.present(mail, animated: true)

        // Show third party email composer if default Mail app is not present
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    static func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")

        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }

        return defaultUrl
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
