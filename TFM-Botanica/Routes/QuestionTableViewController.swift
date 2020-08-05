//
//  QuestionTableViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 12/04/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit
import iOSDropDown

class QuestionTableViewController: UITableViewController {
    
    var activityViewController: ActivityViewController?
    
    var selectedCellIndexPath: IndexPath = IndexPath(row: 0, section: 1)
    
    let questionCellHeight: CGFloat = 88.0
    let answerCellHeight: CGFloat = 55.0
    let finishCellHeight: CGFloat = 55.0
    
    let temporalSizeTable = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.selectRow(at: selectedCellIndexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
        // This will remove extra separators from tableview
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)

        self.updateInterface()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return temporalSizeTable
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        if self.selectedCellIndexPath.row == indexPath.row && indexPath.row != temporalSizeTable - 1{
            let questionCell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionTableViewCell

            questionCell.titleLable.text = "Hola"
            questionCell.answerDropDown.optionArray = ["Option 1", "Option 2", "Option 3"]
            questionCell.answerDropDown.optionIds = [1,23,54,22]
            
            cell = questionCell
        } else if indexPath.row != temporalSizeTable - 1 {
            let answerCell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath)

            answerCell.textLabel!.text = "Hola"
            
            cell = answerCell
        } else {
            let finishCell = tableView.dequeueReusableCell(withIdentifier: "finishCell", for: indexPath)
            
            cell = finishCell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.selectedCellIndexPath.row == indexPath.row && indexPath.row != temporalSizeTable - 1{
            return self.questionCellHeight
        } else if indexPath.row != temporalSizeTable - 1 {
            return self.answerCellHeight
        } else {
            return self.finishCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != temporalSizeTable - 1 {
            self.selectedCellIndexPath = indexPath

            tableView.beginUpdates()
            tableView.endUpdates()

            // This ensures, that the cell is fully visible once expanded
            tableView.scrollToRow(at: indexPath, at: .none, animated: true)
            tableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: .automatic)
        }
    }
    
    @IBAction func finishAction(_ sender: Any) {
        self.activityViewController?.completeRoute()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Functions
    
    func updateInterface() {
        //Create report button
        let reportButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(reportActionButton))
        reportButton.image = UIImage(systemName: "exclamationmark.triangle")
        self.navigationItem.rightBarButtonItems = [reportButton]
    }
    
    @objc func reportActionButton() {
        
    }

}
