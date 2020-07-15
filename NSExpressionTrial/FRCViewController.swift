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
  
  //MARK: - Outlets
  @IBOutlet weak var frcTableView: UITableView!
  
  //MARK: - FRC
  var fetchedResultsController: NSFetchedResultsController<ToDo>!
  
  var fetchedToDoResultsController = CoreDataController.shared.fetchedToDoResultsController
  var fetchedToDoByYearResultsController = CoreDataController.shared.fetchedToDoByYearController
  var fetchedToDoByMonthResultsController = CoreDataController.shared.fetchedToDoByMonthController
  var fetchedToDoByWeekResultsController = CoreDataController.shared.fetchedToDoByWeekController
  
//  var fetchedGoalResultsController = CoreDataController.shared.fetchedGoalResultsController
//  var fetchedGoalByYearResultsController = CoreDataController.shared.fetchedGoalByYearController
//  var fetchedGoalByMonthResultsController = CoreDataController.shared.fetchedGoalByMonthController
//  var fetchedGoalByWeekResultsController = CoreDataController.shared.fetchedGoalByWeekController
  
  var frc1 = CoreDataController.shared.fetchedToDoResultsController
//  var frc2 = CoreDataController.shared.fetchedGoalResultsController
  
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
    //    fetchedToDoByYearResultsController.delegate = self
        fetchedToDoByMonthResultsController.delegate = self  //
    //    fetchedToDoByWeekResultsController.delegate = self

    //    fetchedToDoResultsController.fetchRequest.predicate = allToDoPredicate
    //    fetchedToDoResultsController.fetchRequest.predicate = todoCompletedPredicate
    //    fetchedToDoResultsController.fetchRequest.predicate = pastYearToDoPredicate
    //    fetchedToDoResultsController.fetchRequest.predicate = past6MonthToDoPredicate
    //    fetchedToDoResultsController.fetchRequest.predicate = pastMonthToDoPredicate
    //    fetchedToDoResultsController.fetchRequest.predicate = pastWeekToDoPredicate
    
    //    fetchedToDoByYearResultsController.fetchRequest.predicate = allToDoPredicate
    //    fetchedToDoByYearResultsController.fetchRequest.predicate = todoCompletedPredicate
    
        fetchedToDoByMonthResultsController.fetchRequest.predicate = allToDoPredicate  //
    //    fetchedToDoByMonthResultsController.fetchRequest.predicate = todoCompletedPredicate

    //    fetchedToDoByWeekResultsController.fetchRequest.predicate = allToDoPredicate
    //    fetchedToDoByWeekResultsController.fetchRequest.predicate = todoCompletedPredicate

    // Goals
    //    fetchedGoalResultsController.delegate = self
    //    fetchedGoalResultsController.delegate = self
    //    fetchedGoalByYearResultsController.delegate = self
//    fetchedGoalByMonthResultsController.delegate = self  //
    //    fetchedGoalByWeekResultsController.delegate = self

    //    fetchedGoalResultsController.fetchRequest.predicate = allGoalPredicate
    //    fetchedGoalResultsController.fetchRequest.predicate = goalCompletedPredicate
    //    fetchedGoalResultsController.fetchRequest.predicate = allGoalPredicate
    //    fetchedGoalResultsController.fetchRequest.predicate = pastYearGoalPredicate
    //    fetchedGoalResultsController.fetchRequest.predicate = pastMonthGoalPredicate
    //    fetchedGoalResultsController.fetchRequest.predicate = pastWeekGoalPredicate
    //    fetchedGoalByYearResultsController.fetchRequest.predicate = goalCompletedPredicate
    //    fetchedGoalByYearResultsController.fetchRequest.predicate = allGoalPredicate
    //    fetchedGoalByMonthResultsController.fetchRequest.predicate = goalCompletedPredicate
//    fetchedGoalByMonthResultsController.fetchRequest.predicate = allGoalPredicate  //
    //    fetchedGoalByWeekResultsController.fetchRequest.predicate = goalCompletedPredicate
    //    fetchedGoalByWeekResultsController.fetchRequest.predicate = allGoalPredicate
    
    
    //   frc1 = fetchedToDoResultsController
    //    frc1 = fetchedToDoByYearResultsController
        frc1 = fetchedToDoByMonthResultsController
    //    frc1 = fetchedToDoByWeekResultsController


    //    frc2 = fetchedGoalResultsController
    //    frc2 = fetchedGoalByYearResultsController
    //    frc2 = fetchedGoalByMonthResultsController
    //    frc2 = fetchedGoalByWeekResultsController
    

    
    do {
      try frc1.performFetch()
    } catch {
      print("Fetch frc1 failed")
    }
//    do {
//      try frc2.performFetch()
//    } catch {
//      print("Fetch frc2 failed")
//    }
    /*
    
    let todoSections = frc1.sections
    let todoSectionCount = todoSections?.count
    let todos = frc1.fetchedObjects
    let todosCount = todos?.count
    print("frc1.sections: \(String(describing: todoSections))")
    print("todoSectionCount: \(todoSectionCount ?? 0)")
    print("frc1.todos: \(String(describing: todos))")
    print("todosCount: \(todosCount ?? 0)")
    
    let goalSections = frc2.sections
    let goalSectionCount = goalSections?.count
    let goals = frc2.fetchedObjects
    let goalsCount = goals?.count
    print("frc2.sections: \(String(describing: goalSections))")
    print("goalSectionCount: \(goalSectionCount ?? 0)")
    print("frc2.todos: \(String(describing: goals))")
    print("goalsCount: \(goalsCount ?? 0)")
 */
  }
}
