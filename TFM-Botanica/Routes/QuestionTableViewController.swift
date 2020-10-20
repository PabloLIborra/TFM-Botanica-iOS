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
    
    var responseDictionary = [Question:ResponseQuestion]()
    
    var selectedCellIndexPath: IndexPath = IndexPath(row: 0, section: 1)
    
    let questionCellHeight: CGFloat = 120.0
    let answerCellHeight: CGFloat = 55.0
    let finishCellHeight: CGFloat = 55.0
    
    var tableSize = 0
    
    struct ResponseQuestion {
        var toCorrect: Bool
        var correct: Bool
        var answers: [String]
        var answerResponse: String
    }
    
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
        
        if indexPath.row != self.tableSize - 1{
            let questionCell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionTableViewCell

            questionCell.titleLable.text = self.questions[indexPath.row].title
            questionCell.table = self
            questionCell.question = self.questions[indexPath.row]
            questionCell.trueAnswer = self.questions[indexPath.row].true_answer!.title!
            questionCell.answerDropDown.text = ""
            questionCell.answerDropDown.selectedIndex = -1
            
            let keyExists = self.responseDictionary[self.questions[indexPath.row]] != nil

            if keyExists == true {
                questionCell.answerDropDown.optionArray = self.responseDictionary[self.questions[indexPath.row]]!.answers
                questionCell.changeResponse(response: self.responseDictionary[self.questions[indexPath.row]]!.answerResponse)
                
                let answer = self.responseDictionary[self.questions[indexPath.row]]?.correct
                questionCell.changeColor(toCorrect: self.responseDictionary[self.questions[indexPath.row]]!.toCorrect, correct: answer!)
            } else {
                let answers = self.questions[indexPath.row].answers?.allObjects as! [Answer]
                var answersString: [String] = []
                for answer in answers {
                    answersString.append(answer.title!)
                }
                answersString.shuffle()
                questionCell.answerDropDown.optionArray = answersString
                
                self.responseDictionary[self.questions[indexPath.row]] = ResponseQuestion(toCorrect: false, correct: false, answers: answersString, answerResponse: "")
            }
            questionCell.checkTrueAnswer()
                        
            cell = questionCell
        } else {
            let finishCell = tableView.dequeueReusableCell(withIdentifier: "finishCell", for: indexPath)
            
            cell = finishCell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if /*self.selectedCellIndexPath.row == indexPath.row &&*/ indexPath.row != self.tableSize - 1{
            return self.questionCellHeight
        } else {
            return self.finishCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != self.tableSize - 1 {
            self.selectedCellIndexPath = indexPath
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
        
        for (key, value) in self.responseDictionary {
            let newValue = ResponseQuestion(toCorrect: true, correct: value.correct, answers: value.answers, answerResponse: value.answerResponse)
            self.responseDictionary[key] = newValue
            
            if self.responseDictionary[key]?.correct == false {
                result = false
            }
        }
        
        for visibleCell in self.tableView.visibleCells {
            if let cell = visibleCell as? QuestionTableViewCell {
                let answer = self.responseDictionary[cell.question!]?.correct
                
                cell.changeColor(toCorrect: self.responseDictionary[cell.question!]!.toCorrect, correct: answer!)
            }
        }

        if result == true {
            self.activityViewController?.completedRoute()
            self.showCompletedTestAlertView()
        } else {
            self.showFailedTestAlertView()
        }
    }
    
    func changeStateResponse(toCorrect: Bool, question: Question, isCorrect: Bool, answerResponse: String) {
        var correct = toCorrect
        if self.responseDictionary[question]?.toCorrect == false {
            correct = false
        }
        let newValue = ResponseQuestion(toCorrect: correct, correct: isCorrect, answers: self.responseDictionary[question]!.answers, answerResponse: answerResponse)
        self.responseDictionary[question] = newValue
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
    
    func showFailedTestAlertView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let failedTestController = storyboard.instantiateViewController(withIdentifier: "failedTestController") as! CustomFailedTestAlertViewController
        failedTestController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        failedTestController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        failedTestController.textTitle = "Test Fallido"
        failedTestController.textInformation = "Has fallado en alguna pregunta del test, corrige las respuestas que esten en rojo."
        
        self.present(failedTestController, animated: true, completion: nil)
    }
}
