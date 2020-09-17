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
    var plant: Plant?
    
    var questions: [Question] = []
    
    var selectedCellIndexPath: IndexPath = IndexPath(row: 0, section: 1)
    
    let questionCellHeight: CGFloat = 99.0
    let answerCellHeight: CGFloat = 55.0
    let finishCellHeight: CGFloat = 55.0
    
    var tableSize = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background-questions.jpeg"))
        self.tableView.backgroundView?.contentMode = .scaleAspectFill
        self.tableView.backgroundView?.alpha = 0.3
        
        self.tableView.selectRow(at: selectedCellIndexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
        // This will remove extra separators from tableview
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)

        self.updateInterface()
        self.updateQuestionData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tableSize
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        if /*self.selectedCellIndexPath.row == indexPath.row &&*/ indexPath.row != self.tableSize - 1{
            let questionCell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionTableViewCell

            questionCell.titleLable.text = self.questions[indexPath.row].title
            let answers = self.questions[indexPath.row].answers?.allObjects as! [Answer]
            var answersString: [String] = []
            for answer in answers {
                answersString.append(answer.title!)
            }
            answersString.shuffle()
            questionCell.answerDropDown.optionArray = answersString
            questionCell.trueAnswer = self.questions[indexPath.row].true_answer!.title!
            questionCell.checkTrueAnswer()
            
            cell = questionCell
        } /*else if indexPath.row != self.tableSize - 1 {
            let answerCell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath)

            answerCell.textLabel!.text = self.questions[indexPath.row].title
            
            cell = answerCell
        }*/ else {
            let finishCell = tableView.dequeueReusableCell(withIdentifier: "finishCell", for: indexPath)
            
            cell = finishCell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if /*self.selectedCellIndexPath.row == indexPath.row &&*/ indexPath.row != self.tableSize - 1{
            return self.questionCellHeight
        } /*else if indexPath.row != self.tableSize - 1 {
            return self.answerCellHeight
        }*/ else {
            return self.finishCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != self.tableSize - 1 {
            self.selectedCellIndexPath = indexPath
            /*
            tableView.beginUpdates()
            tableView.endUpdates()

            // This ensures, that the cell is fully visible once expanded
            tableView.scrollToRow(at: indexPath, at: .none, animated: true)
            tableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: .automatic)
            */
        }
    }
    
    // MARK: Functions
    func updateInterface() {
        //Create report button
        let reportButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(reportActionButton))
        reportButton.image = UIImage(systemName: "exclamationmark.triangle")
        self.navigationItem.rightBarButtonItems = [reportButton]
    }
    
    @objc func reportActionButton() {
        CustomReportAlertViewController.shared.showReportAlertViewController(view: self)
    }
    
    func updateQuestionData() {
        self.questions = plant!.questions?.allObjects as! [Question]
        self.questions.sort(by: { $0.date!.compare($1.date!) == .orderedAscending })
        self.tableSize = self.questions.count + 1
    }
    
    @IBAction func finishAction(_ sender: Any) {
        var result = true
        for i in 0..<tableSize-1 {
            let indexPath = IndexPath(row: i, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as! QuestionTableViewCell
            if result == true && cell.isCorrected == false {
                result = cell.isCorrected
            }
            cell.changeColor()
        }
        if result == true {
            self.activityViewController?.completedRoute()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showCompletedTestAlertView()
            }
        }
    }
    
    func showCompletedTestAlertView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let completedTestController = storyboard.instantiateViewController(withIdentifier: "completedTestController") as! CustomTestAlertViewController
        completedTestController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        completedTestController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        completedTestController.textTitle = "Test Completado"
        completedTestController.textInformation = "Has completado con éxito el test.\nYa puedes ver con detalle la planta oculta."
        completedTestController.plant = self.plant
        
        self.present(completedTestController, animated: true, completion: nil)
    }
}
