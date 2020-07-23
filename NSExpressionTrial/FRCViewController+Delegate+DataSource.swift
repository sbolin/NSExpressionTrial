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
      goalRowsInSection = numberOfRows / 3
      numberOfRows += goalRowsInSection ?? 0
      return (numberOfRows + 1) // + 1 for summary cell
    } else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let section = indexPath.section
    if indexPath.row == 0 {
      let summaryCell = tableView.dequeueReusableCell(withIdentifier: "FRCSummaryCell", for: indexPath)
      let goalCount = statistics.goalCount[section]
      let goalCompleted = statistics.goalComplete[section]
//      let goalIncompleted = statistics.goalIncomplete[section]
      let goalDuration = statistics.goalDuration[section]
      let mainTitle = "\(goalCompleted) Goals Complete out of \(goalCount) - \(goalDuration) Days"
      
      let todoCount = statistics.todoCount[section]
      let todoCompleted = statistics.todoComplete[section]
//      let todoIncompleted = statistics.todoIncomplete[section]
      let todoDuration = statistics.todoDuration[section]
      let subTitle = "\(todoCompleted) Todos Complete out of \(todoCount) - \(todoDuration) Days"
      summaryCell.textLabel?.text = mainTitle
      summaryCell.detailTextLabel?.text = subTitle
      return summaryCell
    } else if (indexPath.row - 1) % 4 == 0 {
      let offset: Int = indexPath.row / 4 + 1
      let previousIndex = IndexPath(row: indexPath.row - offset, section: indexPath.section)
      let todoObject = frc1.object(at: previousIndex)
      let goalObject = todoObject.goal
      let goalcell = tableView.dequeueReusableCell(withIdentifier: "FRCGoalCell", for: indexPath)
      goalcell.textLabel?.text = "\(goalObject.goal) - s\(indexPath.section), r\(indexPath.row)"
      if goalObject.goalCompleted {
        let diffComponents = Calendar.current.dateComponents([.day], from: goalObject.goalDateCreated, to: goalObject.goalDateCompleted!)
        let daysToCompleteGoal = diffComponents.day!
        goalcell.detailTextLabel?.text = "Goal completed in: \(daysToCompleteGoal) days"
      } else {
        goalcell.detailTextLabel?.text = "Goal completed: \(goalObject.goalCompleted)"
      }
      return goalcell
    } else {
      let offset: Int = (indexPath.row - 1) / 4 + 2
      let previousIndex = IndexPath(row: indexPath.row - offset, section: indexPath.section)
      let todoObject = frc1.object(at: previousIndex)
      let todocell = tableView.dequeueReusableCell(withIdentifier: "FRCToDoCell", for: indexPath)
      todocell.textLabel?.text = "\(todoObject.todo) - s\(indexPath.section), r\(indexPath.row)"
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
}
