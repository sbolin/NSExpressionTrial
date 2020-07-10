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
    print("didSelectRowAt")
    print(indexPath)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    print("heightForRowAt")
    let row = indexPath.row
    switch row {
    case 0:
      return 64
    default:
      return 55
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    print("heightForHeaderInSection")
    return groupedResults.count == 0 ? 0 : 36
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    print("viewForHeaderInSection")
    let view = UITableViewHeaderFooterView()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MMM-YY"
    view.textLabel?.textColor = UIColor.systemOrange
    view.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    view.textLabel?.frame = view.frame
    view.textLabel?.textAlignment = .center
//    view.textLabel?.text = CoreDataController.shared.fetchedToDoByMonthController.sections?[section].name
//    view.textLabel?.text = frc1.sections?[section].name
    
    if groupedResults.count == 0 {
      return nil
    }
    
    if let date = groupedResults[section].first?.goalCreated {
      let title = dateFormatter.string(from: date)
          view.textLabel?.text = title
    }
    return view
  }
}

//MARK: - TableView DataSource
extension ViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {

//    print("number of Sections: \(frc1.sections?.count ?? 0)")
//    return frc1.sections?.count ?? 0
    return groupedResults.count > 0 ? groupedResults.count : 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return groupedResults[section].count + 1 // 1 goal + count
    /*
    // baseed on frc
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
    // end frc
 */
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.row % 4 == 0 {
      let goalItem = groupedResults[indexPath.section][indexPath.row]
      let goalcell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath)
      goalcell.backgroundColor = .systemGray6
      goalcell.textLabel?.text = goalItem.goal
      print("Goal @ indexPath: \(indexPath.section), \(indexPath.row): ", goalItem.goalComplete)
      goalcell.detailTextLabel?.text = "Goal completed: \(goalItem.goalComplete)"
      return goalcell
    }
    let offset: Int = indexPath.row / 4 + 1
    let previousIndex = IndexPath(row: indexPath.row - offset, section: indexPath.section)
    let todoItem = groupedResults[indexPath.section][previousIndex.row]
    let todocell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
    todocell.textLabel?.text = todoItem.todo
    print("Todo @ indexPath: \(previousIndex.section), \(previousIndex.row): ", todoItem.todoComplete)
    todocell.detailTextLabel?.text = "Todo completed: \(todoItem.todoComplete)"
    return todocell
    
    /*
    // frc method
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
    let previousIndex = IndexPath(row: indexPath.row - offset, section: indexPath.section)
    let todoObject = frc1.object(at: previousIndex)
    let todocell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
    todocell.textLabel?.text = todoObject.todo
    todocell.detailTextLabel?.text = todoObject.todoCompleted.description
    print("todoObject.todo: \(todoObject.todo)")
    return todocell
    // end frc method
    //
 */
  }
}
