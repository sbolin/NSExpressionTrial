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
  
  var fetchedToDoYearResultsController = CoreDataController.shared.fetchedToDoByYearController
  var fetchedToDoMonthResultsController = CoreDataController.shared.fetchedToDoByMonthController
  var fetchedToDoWeekResultsController = CoreDataController.shared.fetchedToDoByWeekController
  var fetchedToDoAllResultsController = CoreDataController.shared.fetchedToDoResultsController
  
  var fetchedGoalYearResultsController = CoreDataController.shared.fetchedGoalByYearController
  var fetchedGoalMonthResultsController = CoreDataController.shared.fetchedGoalByMonthController
  var fetchedGoalWeekResultsController = CoreDataController.shared.fetchedGoalByWeekController
  var fetchedGoalAllResultsController = CoreDataController.shared.fetchedGoalResultsController
  
  var frc1 = CoreDataController.shared.fetchedToDoByMonthController
  var frc2 = CoreDataController.shared.fetchedGoalByMonthController
  
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
      fetchedResultsController = CoreDataController.shared.fetchedToDoResultsController
    }
    //    fetchedResultsController.fetchRequest.predicate = predicate
    do {
      try fetchedResultsController.performFetch()
      frcTableView.reloadData()
    } catch {
      print("Fetch failed")
    }
  }
  
  func frcSetup() {
    print("\n\n 5. setupByMonthController - frc\n")
    
    //    fetchedToDoResultsController.delegate = self
    //    fetchedGoalResultsController.delegate = self
    //    fetchedToDoResultsController.fetchRequest.predicate = allToDoPredicate
    //    fetchedGoalResultsController.fetchRequest.predicate = allGoalPredicate
    
    //    fetchedToDoAllResultsController.delegate = self
    //    fetchedGoalAllResultsController.delegate = self
    //    fetchedToDoAllResultsController.fetchRequest.predicate = todoCompletedPredicate
    //    fetchedGoalAllResultsController.fetchRequest.predicate = goalCompletedPredicate
    //    fetchedToDoAllResultsController.fetchRequest.predicate = allToDoPredicate
    //    fetchedGoalAllResultsController.fetchRequest.predicate = allGoalPredicate

    //    fetchedToDoYearResultsController.delegate = self
    //    fetchedGoalYearResultsController.delegate = self
    //    fetchedToDoYearResultsController.fetchRequest.predicate = todoCompletedPredicate
    //    fetchedGoalYearResultsController.fetchRequest.predicate = goalCompletedPredicate
    //    fetchedToDoYearResultsController.fetchRequest.predicate = allToDoPredicate
    //    fetchedGoalYearResultsController.fetchRequest.predicate = allGoalPredicate
    
//    fetchedToDoMonthResultsController.delegate = self  //
//    fetchedGoalMonthResultsController.delegate = self  //
    //    fetchedToDoMonthResultsController.fetchRequest.predicate = todoCompletedPredicate
    //    fetchedGoalMonthResultsController.fetchRequest.predicate = goalCompletedPredicate
//    fetchedToDoMonthResultsController.fetchRequest.predicate = allToDoPredicate  //
//    fetchedGoalMonthResultsController.fetchRequest.predicate = allGoalPredicate  //
    //
        fetchedToDoWeekResultsController.delegate = self
        fetchedGoalWeekResultsController.delegate = self
    //    fetchedToDoWeekResultsController.fetchRequest.predicate = todoCompletedPredicate
    //    fetchedGoalWeekResultsController.fetchRequest.predicate = goalCompletedPredicate
        fetchedToDoWeekResultsController.fetchRequest.predicate = allToDoPredicate
        fetchedGoalWeekResultsController.fetchRequest.predicate = allGoalPredicate
    
 
//    frc1 = fetchedToDoAllResultsController
//    frc2 = fetchedGoalAllResultsController
//    frc1 = fetchedToDoYearResultsController
//    frc2 = fetchedGoalYearResultsController
//    frc1 = fetchedToDoMonthResultsController
//    frc2 = fetchedGoalMonthResultsController
    frc1 = fetchedToDoWeekResultsController
    frc2 = fetchedGoalWeekResultsController
    

    
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
