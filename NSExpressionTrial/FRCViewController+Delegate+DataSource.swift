//
//  FRCViewController+Delegate+DataSource.swift
//  NSExpressionTrial
//
//  Created by Scott Bolin on 7/14/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

//MARK: - TableView Delegate
extension FRCViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if (indexPath.row % 4) == 0 {
      return 64
    } else {
      return 55
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 32
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UITableViewHeaderFooterView()
    view.textLabel?.textColor = UIColor.systemOrange
    view.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    view.textLabel?.frame = view.frame
    view.textLabel?.textAlignment = .center
    view.textLabel?.text = frc1.sections?[section].name
    return view
  }
}

//MARK: - TableView DataSource
extension FRCViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return frc1.sections?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    todoRowsInSection = frc1.sections?[section].numberOfObjects
    if var numberOfRows = todoRowsInSection  {
      goalRowsInSection = numberOfRows / 3 //(numberOfRows - 1) / 3 + 1
      numberOfRows += goalRowsInSection ?? 1
      return numberOfRows
    } else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if (indexPath.row % 4) == 0 {
      let todoObject = frc1.object(at: indexPath)
      let goalObject = todoObject.goal
      let goalcell = tableView.dequeueReusableCell(withIdentifier: "FRCGoalCell", for: indexPath)
      goalcell.textLabel?.text = goalObject.goal
      if goalObject.goalCompleted {
        let diffComponents = Calendar.current.dateComponents([.day], from: goalObject.goalDateCreated, to: goalObject.goalDateCompleted!)
        let daysToCompleteGoal = diffComponents.day!
        goalcell.detailTextLabel?.text = "Goal completed in: \(daysToCompleteGoal) days"
      } else {
        goalcell.detailTextLabel?.text = "Goal completed: \(goalObject.goalCompleted)"
      }
      return goalcell
    }
    let offset: Int = indexPath.row / 4 + 1
    let previousIndex = IndexPath(row: indexPath.row - offset, section: indexPath.section)
    let todoObject = frc1.object(at: previousIndex)
    let todocell = tableView.dequeueReusableCell(withIdentifier: "FRCToDoCell", for: indexPath)
    todocell.textLabel?.text = todoObject.todo
    if todoObject.todoCompleted {
      let diffComponents = Calendar.current.dateComponents([.day], from: todoObject.todoDateCreated, to: todoObject.todoDateCompleted!)
      let daysToCompleteTodo = diffComponents.day!
      todocell.detailTextLabel?.text = "Todo completed in: \(daysToCompleteTodo) days"
    } else {
      todocell.detailTextLabel?.text = "Todo completed: \(todoObject.todoCompleted)"
    }
    return todocell
  }
}
