//
//  CreditsTableViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 16/09/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit

class CreditsTableViewController: UITableViewController {
    
    let sections = ["Desarrollador", "Colaboraciones", "Propuesta", "Recursos externos"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This will remove extra separators from tableview
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background-credits.jpeg"))
        self.tableView.backgroundView?.contentMode = .scaleAspectFill
        self.tableView.backgroundView?.alpha = 0.3
        
        self.tableView.contentInset.top = 10.0
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
            return self.sections[section]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("CustomHeaderCreditsTableViewCell", owner: self, options: nil)?.first as! CustomHeaderCreditsTableViewCell
        
        headerView.nameLabel.text = self.sections[section]
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "creditsCell", for: indexPath) as! CreditsTableViewCell

        var text: String?
        switch indexPath.section {
        case 0:
            text = "Pablo López Iborra\np.lopez.iborra@gmail.com"
        case 1:
            text = "Sergio Cabañero García\n19sergio98@gmail.com\n\nMiguel Ángel Lozano Ortega\nmalozano@ua.es\nDpto. Ciencia de la Computacion e Inteligencia Artificial\n\nMaría Ángeles Alonso Vargas\nma.alonso@gcloud.ua.es\nDpto. Ciencias Ambientales y Recursos Naturales\n\nManuel Benito Crespo Villalba\ncrespo@mscloud.ua.es\nDpto. Ciencias Ambientales y Recursos Naturales\n\nUniversidad de Alicante"
        case 2:
            text = "Máster en Desarrollo de Software para Dispositivos Móviles\nPropuesta realizada como\nTrabajo de Final de Máster (TFM)"
        case 3:
            text = "Pods\n\nGoogle Maps\nGoogle Places\nFlexible Page Control\nIOS Drop Down"
        default:
            text = ""
        }
        cell.textView.text = text
        
        return cell
    }

}
