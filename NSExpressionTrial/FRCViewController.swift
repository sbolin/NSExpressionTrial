//
//  FRCViewController.swift
//  NSExpressionTrial
//
//  Created by Scott Bolin on 7/14/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit
import CoreData

class FRCViewController: UIViewController, NSFetchedResultsControllerDelegate {
  
  //MARK: - Properties
  var todoRowsInSection: Int?
  var goalRowsInSection: Int?
  var statistics = Statistics()
  
  //MARK: - Outlets
  @IBOutlet weak var frcTableView: UITableView!
  
  //MARK: - FRC
  var fetchedResultsController: NSFetchedResultsController<ToDo>!
  
  var fetchedToDoResultsController = CoreDataController.shared.fetchedToDoResultsController
  var fetchedToDoByYearResultsController = CoreDataController.shared.fetchedToDoByYearController
  var fetchedToDoByMonthResultsController = CoreDataController.shared.fetchedToDoByMonthController
  var fetchedToDoByWeekResultsController = CoreDataController.shared.fetchedToDoByWeekController
  
  var fetchedGoalResultsController = CoreDataController.shared.fetchedGoalResultsController
  var fetchedGoalByYearResultsController = CoreDataController.shared.fetchedGoalByYearController
  var fetchedGoalByMonthResultsController = CoreDataController.shared.fetchedGoalByMonthController
  var fetchedGoalByWeekResultsController = CoreDataController.shared.fetchedGoalByWeekController
  
  var frc1 = CoreDataController.shared.fetchedToDoResultsController
  var frc2 = CoreDataController.shared.fetchedGoalResultsController
  
  //MARK: - Date setup for Predicates
  let lastDay = Date().addingTimeInterval(-60 * 60 * 24) as NSDate
  let lastWeek = Date().addingTimeInterval(-60 * 60 * 24 * 7) as NSDate
  let lastMonth = Date().addingTimeInterval(-60 * 60 * 24 * 30) as NSDate
  let last6Month = Date().addingTimeInterval(-60 * 60 * 24 * 183) as NSDate
  let lastYear = Date().addingTimeInterval(-60 * 60 * 24 * 365) as NSDate
  let allTime = Date().addingTimeInterval(-60 * 60 * 24 * 365 * 10) as NSDate // 10 year to show all todos.
  
  
  //MARK: Date Goal Predicates
  lazy var allGoalPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(Goal.goalDateCreated), allTime)
  }()
  
  lazy var pastDayGoalPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(Goal.goalDateCreated), lastDay)
  }()
  
  lazy var pastWeekGoalPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(Goal.goalDateCreated), lastWeek)
  }()
  
  lazy var pastMonthGoalPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(Goal.goalDateCreated), lastMonth)
  }()
  
  lazy var past6MonthGoalPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(Goal.goalDateCreated), last6Month)
  }()
  
  lazy var pastYearGoalPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(Goal.goalDateCreated), lastYear)
  }()
  
  lazy var goalCompletedPredicate: NSPredicate = {
    return NSPredicate(format: "%K = %d", #keyPath(Goal.goalCompleted), true)
  }()
  
  lazy var goalByMonthPredicate: NSPredicate = {
    return NSPredicate(format: "%K = %d", #keyPath(Goal.goalDateCreated), allTime)
  }()
  
  //MARK: Date ToDo Predicates
  lazy var allToDoPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(ToDo.todoDateCreated), allTime)
  }()
  
  lazy var pastDayToDoPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(ToDo.todoDateCreated), lastDay)
  }()
  
  lazy var pastWeekToDoPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(ToDo.todoDateCreated), lastWeek)
  }()
  
  lazy var pastMonthToDoPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(ToDo.todoDateCreated), lastMonth)
  }()
  
  lazy var past6MonthToDoPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(ToDo.todoDateCreated), last6Month)
  }()
  
  lazy var pastYearToDoPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(ToDo.todoDateCreated), allTime)
  }()
  
  lazy var todoCompletedPredicate: NSPredicate = {
    return NSPredicate(format: "%K = %d", #keyPath(ToDo.todoCompleted), true)
  }()
  
  lazy var todoByMonthPredicate: NSPredicate = {
    return NSPredicate(format: "%K = %d", #keyPath(ToDo.todoDateCreated), true)
  }()
  
  //MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    frcTableView.delegate = self
    frcTableView.dataSource = self
    
    setupTableView()
    frcSetup()
    frcTableView.reloadData()
    
  }
  
  func setupTableView() {
    if fetchedResultsController == nil {
      fetchedResultsController = fetchedToDoResultsController
    }
    do {
      try fetchedResultsController.performFetch()
      frcTableView.reloadData()
    } catch {
      print("Fetch failed")
    }
  }
  
  func frcSetup() {
    print("\n\n 5. setupByMonthController - frc\n")
    
    // TODO
    //    fetchedToDoResultsController.delegate = self
    //    fetchedToDoResultsController.fetchRequest.predicate = allToDoPredicate
    //    fetchedToDoResultsController.fetchRequest.predicate = pastYearToDoPredicate
    //    fetchedToDoResultsController.fetchRequest.predicate = past6MonthToDoPredicate
    //    fetchedToDoResultsController.fetchRequest.predicate = pastMonthToDoPredicate
    //    fetchedToDoResultsController.fetchRequest.predicate = pastWeekToDoPredicate
    //    fetchedToDoResultsController.fetchRequest.predicate = todoCompletedPredicate

    //    fetchedToDoByYearResultsController.delegate = self
    //    fetchedToDoByYearResultsController.fetchRequest.predicate = allToDoPredicate
    //    fetchedToDoByYearResultsController.fetchRequest.predicate = pastYearToDoPredicate
    //    fetchedToDoByYearResultsController.fetchRequest.predicate = past6MonthToDoPredicate
    //    fetchedToDoByYearResultsController.fetchRequest.predicate = pastMonthToDoPredicate
    //    fetchedToDoByYearResultsController.fetchRequest.predicate = todoCompletedPredicate

        fetchedToDoByMonthResultsController.delegate = self  //
        fetchedToDoByMonthResultsController.fetchRequest.predicate = allToDoPredicate  //
    //    fetchedToDoByMonthResultsController.fetchRequest.predicate = pastYearToDoPredicate
    //    fetchedToDoByMonthResultsController.fetchRequest.predicate = past6MonthToDoPredicate
    //    fetchedToDoByMonthResultsController.fetchRequest.predicate = pastMonthToDoPredicate
    //    fetchedToDoByMonthResultsController.fetchRequest.predicate = todoCompletedPredicate

    //    fetchedToDoByWeekResultsController.delegate = self
    //    fetchedToDoByWeekResultsController.fetchRequest.predicate = allToDoPredicate
    //    fetchedToDoByWeekResultsController.fetchRequest.predicate = pastYearToDoPredicate
    //    fetchedToDoByWeekResultsController.fetchRequest.predicate = past6MonthToDoPredicate
    //    fetchedToDoByWeekResultsController.fetchRequest.predicate = pastMonthToDoPredicate
    //    fetchedToDoByWeekResultsController.fetchRequest.predicate = todoCompletedPredicate
    
    // GOAL
    //    fetchedGoalResultsController.delegate = self
    //    fetchedGoalResultsController.fetchRequest.predicate = allGoalPredicate
    //    fetchedGoalResultsController.fetchRequest.predicate = pastYearGoalPredicate
    //    fetchedGoalResultsController.fetchRequest.predicate = past6MonthGoalPredicate
    //    fetchedGoalResultsController.fetchRequest.predicate = pastMonthGoalPredicate
    //    fetchedGoalResultsController.fetchRequest.predicate = pastWeekGoalPredicate
    //    fetchedGoalResultsController.fetchRequest.predicate = goalCompletedPredicate

    //    fetchedGoalByYearResultsController.delegate = self
    //    fetchedGoalByYearResultsController.fetchRequest.predicate = allGoalPredicate
    //    fetchedGoalByYearResultsController.fetchRequest.predicate = pastYearGoalPredicate
    //    fetchedGoalByYearResultsController.fetchRequest.predicate = past6MonthGoalPredicate
    //    fetchedGoalByYearResultsController.fetchRequest.predicate = pastMonthGoalPredicate
    //    fetchedGoalByYearResultsController.fetchRequest.predicate = goalCompletedPredicate

        fetchedGoalByMonthResultsController.delegate = self  //
        fetchedGoalByMonthResultsController.fetchRequest.predicate = allGoalPredicate  //
    //    fetchedGoalByMonthResultsController.fetchRequest.predicate = pastYearGoalPredicate
    //    fetchedGoalByMonthResultsController.fetchRequest.predicate = past6MonthGoalPredicate
    //    fetchedGoalByMonthResultsController.fetchRequest.predicate = pastMonthGoalPredicate
    //    fetchedGoalByMonthResultsController.fetchRequest.predicate = goalCompletedPredicate

    //    fetchedGoalByWeekResultsController.delegate = self
    //    fetchedGoalByWeekResultsController.fetchRequest.predicate = allGoalPredicate
    //    fetchedGoalByWeekResultsController.fetchRequest.predicate = pastYearGoalPredicate
    //    fetchedGoalByWeekResultsController.fetchRequest.predicate = past6MonthGoalPredicate
    //    fetchedGoalByWeekResultsController.fetchRequest.predicate = pastMonthGoalPredicate
    //    fetchedGoalByWeekResultsController.fetchRequest.predicate = goalCompletedPredicate

    
    //    frc1 = fetchedToDoResultsController
    //    frc1 = fetchedToDoByYearResultsController
    frc1 = fetchedToDoByMonthResultsController
    //    frc1 = fetchedToDoByWeekResultsController
    
    //    frc2 = fetchedGoalResultsController
    //    frc2 = fetchedGoalByYearResultsController
    frc2 = fetchedGoalByMonthResultsController
    //   frc2 = fetchedGoalByWeekResultsController
    
    do {
      try frc1.performFetch()
    } catch {
      print("Fetch frc1 failed")
    }
    
    do {
      try frc2.performFetch()
    } catch {
      print("Fetch frc2 failed")
    }
    
    print("Counts by section:")
    print("Section   TodoCount   Complete   Incomplete   Days to Complete")
    
    guard let todoSections = frc1.sections?.count else { return }
    for section in 0...(todoSections - 1) {
      statistics.todoDuration.append(0)
      guard let todoSectionObject = frc1.sections?[section].objects as? [ToDo] else { return }
      statistics.todoCount.append(todoSectionObject.count)
      let tempCount = todoSectionObject.filter { (todo) -> Bool in
        todo.todoCompleted == true
      }.count
      statistics.todoComplete.append(tempCount)
      for todo in todoSectionObject {
        if todo.todoCompleted {
          let diffComponents = Calendar.current.dateComponents([.day], from: todo.todoDateCreated, to: todo.todoDateCompleted!)
          statistics.todoDuration[section] += diffComponents.day!
        }
      }
      statistics.todoIncomplete.append(statistics.todoCount[section] - statistics.todoComplete[section])
      print("    \(section)        \(statistics.todoCount[section])           \(statistics.todoComplete[section])          \(statistics.todoIncomplete[section])          \(statistics.todoDuration[section])")
    }
    
    print("\n\n")
    print("Section   GoalCount   Complete   Incomplete   Days to Complete")
    
    guard let goalSections = frc2.sections?.count else { return }
    for section in 0...(goalSections - 1) {
      statistics.goalDuration.append(0)
      guard let goalSectionObject = frc2.sections?[section].objects as? [Goal] else { return }
      statistics.goalCount.append(goalSectionObject.count)
      let tempCount = goalSectionObject.filter { (goal) -> Bool in
        goal.goalCompleted == true
      }.count
      statistics.goalComplete.append(tempCount)
      for goal in goalSectionObject {
        if goal.goalCompleted {
          let diffComponents = Calendar.current.dateComponents([.day], from: goal.goalDateCreated, to: goal.goalDateCompleted!)
          statistics.goalDuration[section] += diffComponents.day!
        }
      }
      statistics.goalIncomplete.append(statistics.goalCount[section] - statistics.goalComplete[section])
      print("    \(section)        \(statistics.goalCount[section])           \(statistics.goalComplete[section])          \(statistics.goalIncomplete[section])           \(statistics.goalDuration[section])")
    }
  }
}
