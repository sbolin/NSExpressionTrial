//
//  ViewController+Delegate+DataSource.swift
//  NSExpressionTrial
//
//  Created by Scott Bolin on 7/3/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

//MARK: - TableView Delegate
extension ViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let row = indexPath.row
    switch row {
    case 0:
      return 60
    default:
      return 48
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 36
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(indexPath)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UITableViewHeaderFooterView()
    view.textLabel?.textColor = UIColor.systemOrange
    view.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    view.textLabel?.frame = view.frame
    view.textLabel?.textAlignment = .center
//    view.textLabel?.text = CoreDataController.shared.fetchedToDoByMonthController.sections?[section].name
    view.textLabel?.text = frc1.sections?[section].name
//    view.textLabel?.text = "Section \(section)"
    return view
  }
}


//MARK: - TableView DataSource
extension ViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
//    return CoreDataController.shared.fetchedGoalByMonthController.sections?.count ?? 0
    print("number of Sections: \(frc1.sections?.count ?? 0)")
    return frc1.sections?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    todoRowsInSection = frc1.sections?[section].numberOfObjects
    if var numberOfRows = todoRowsInSection  {
      goalRowsInSection = (numberOfRows - 1) / 3 + 1
      numberOfRows += goalRowsInSection ?? 1
      print("section # \(section)")
      print("number of rows: \(numberOfRows)")
      return numberOfRows
    } else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    print("in cellForRowAt")
    print("indexPath.row = \(indexPath.row)")
    print("indexPath.section = \(indexPath.section)")
    print("frc1 is: \(frc1.self)")
    print("frc2 is: \(frc2.self)")

    if (indexPath.row % 4) == 0 {
//    if indexPath.row == 0 {
      let todoObject = frc1.object(at: indexPath)
      let goalObject = todoObject.goal
      let goalcell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath)
      goalcell.textLabel?.text = goalObject.goal
      goalcell.detailTextLabel?.text = goalObject.goalCompleted.description
      print("goalObject.goal: \(goalObject.goal)")
      return goalcell
    }
    let offset: Int = indexPath.row / 4 + 1
//    let offset: Int = 1
    let previousIndex = IndexPath(row: indexPath.row - offset, section: indexPath.section)
    let todoObject = frc1.object(at: previousIndex)
    let todocell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
    todocell.textLabel?.text = todoObject.todo
    todocell.detailTextLabel?.text = todoObject.todoCompleted.description
    print("todoObject.todo: \(todoObject.todo)")

    return todocell
  }
}
