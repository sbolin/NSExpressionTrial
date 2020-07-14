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
//    return groupedResults.count == 0 ? 0 : 36
    return 36
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UITableViewHeaderFooterView()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM-YY" // "dd-MMM-YY"
    view.textLabel?.textColor = UIColor.systemOrange
    view.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    view.textLabel?.frame = view.frame
    view.textLabel?.textAlignment = .center
    if groupedResults.count == 0 {
      return nil
    }
    if let date = groupedResults[section].first?.goalGroupByMonth {
          view.textLabel?.text = date
    }
    return view
  }
}

//MARK: - TableView DataSource
extension ViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    print("numberOfSections: \(groupedResults.count)")
    return groupedResults.count > 0 ? groupedResults.count : 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    todoRowsInSection = groupedResults[section].count
    print("numberOfRowsInSection: todoRowsInSection \(section) \(todoRowsInSection ?? 0)")
    if var rowsInSection = todoRowsInSection  {
      goalRowsInSection = rowsInSection / 3 // (numberOfRows - 1) / 3 + 1
      rowsInSection += goalRowsInSection ?? 1
      print("numberOfRowsInSection: numberOfRows \(section) \(rowsInSection)")
      return rowsInSection
    } else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if (indexPath.row) % 4 == 0 {
      print("Grouped - IndexPath: Section \(indexPath.section), Row \(indexPath.row)")
      let goalItem = groupedResults[indexPath.section][indexPath.row]
      let goalcell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath)
      goalcell.backgroundColor = .systemGray6
      goalcell.textLabel?.text = "\(goalItem.goal) - \(indexPath.section) - \(indexPath.row)"
      if goalItem.goalComplete {
        let daysToCompleteGoal = goalItem.goalDuration / 86400
        goalcell.detailTextLabel?.text = "Goal completed in: \(daysToCompleteGoal) days"
      } else {
        goalcell.detailTextLabel?.text = "Goal completed: \(goalItem.goalComplete)"
      }
      return goalcell
    } else {
      print("Grouped - IndexPath: Section \(indexPath.section), Row \(indexPath.row)")
      let offset: Int = indexPath.row / 4 + 1
      let previousIndex = IndexPath(row: indexPath.row - offset, section: indexPath.section)
      let todoItem = groupedResults[indexPath.section][previousIndex.row]
      let todocell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
      todocell.textLabel?.text = "\(todoItem.todo) - \(indexPath.section) - \(indexPath.row)"
      if todoItem.todoComplete {
        let daysToCompleteToDo = todoItem.todoDuration / 86400
        todocell.detailTextLabel?.text = "Todo completed in: \(daysToCompleteToDo) days"
      } else {
        todocell.detailTextLabel?.text = "Todo completed: \(todoItem.todoComplete)"
      }
      return todocell
    }
    /*
    // frc method
    if (indexPath.row % 4) == 0 {
//    if indexPath.row == 0 {
      let todoObject = frc1.object(at: indexPath)
      let goalObject = todoObject.goal
      let goalcell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath)
      goalcell.textLabel?.text = goalObject.goal
      goalcell.detailTextLabel?.text = goalObject.goalCompleted.description
      return goalcell
    }
    let offset: Int = indexPath.row / 4 + 1
    let previousIndex = IndexPath(row: indexPath.row - offset, section: indexPath.section)
    let todoObject = frc1.object(at: previousIndex)
    let todocell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
    todocell.textLabel?.text = todoObject.todo
    todocell.detailTextLabel?.text = todoObject.todoCompleted.description
    return todocell
    // end frc method
    //
 */
  }
}
