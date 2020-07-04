//
//  ViewController.swift
//  NSExpressionTrial
//
//  Created by Scott Bolin on 6/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, NSFetchedResultsControllerDelegate {
  
  //MARK: - Properties
  var goals = [Goal]()
  var todolist = [ToDo]()
  
  var todoRowsInSection: Int?
  var goalRowsInSection: Int?
  
  var fetchedToDoYearResultsController = CoreDataController.shared.fetchedToDoByYearController
  var fetchedToDoMonthResultsController = CoreDataController.shared.fetchedToDoByMonthController
  var fetchedToDoWeekResultsController = CoreDataController.shared.fetchedToDoByWeekController
  var fetchedToDoResultsController = CoreDataController.shared.fetchedToDoResultsController
  var fetchedToDoAllResultsController = CoreDataController.shared.fetchedToDoResultsController
  
  var fetchedGoalYearResultsController = CoreDataController.shared.fetchedGoalByYearController
  var fetchedGoalMonthResultsController = CoreDataController.shared.fetchedGoalByMonthController
  var fetchedGoalWeekResultsController = CoreDataController.shared.fetchedGoalByWeekController
  var fetchedGoalResultsController = CoreDataController.shared.fetchedGoalResultsController
  var fetchedGoalAllResultsController = CoreDataController.shared.fetchedGoalResultsController
  
  var frc1 = CoreDataController.shared.fetchedToDoResultsController
  var frc2 = CoreDataController.shared.fetchedGoalResultsController
  
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
  
  //MARK:- IBOutlets
  @IBOutlet weak var todayTableView: UITableView!
  
  //MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    todayTableView.delegate = self
    todayTableView.dataSource = self
    
    todayTableView.register(UITableViewCell.self, forCellReuseIdentifier: "GoalCell")
    todayTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ToDoCell")

    setupToDoTableView()
//    setupGroupSubSections()
//    setupToDoSubSections()
//    populateCounts()
    setupByMonthController()
    todayTableView.reloadData()
    
  }
  
  func setupToDoTableView() {
    // temp
    CoreDataController.shared.createToDosIfNeeded()
    let goalFetch: NSFetchRequest = Goal.goalFetchRequest()
    let todoFetch: NSFetchRequest = ToDo.todoFetchRequest()
    do {
      goals = try CoreDataController.shared.managedContext.fetch(goalFetch)
      todolist = try CoreDataController.shared.managedContext.fetch(todoFetch)
    } catch {
      NSLog("Error fetching entity: %@", error.localizedDescription)
      print("Error fetching entity: \(error)")
    }
    // end temp
    
    let goalCount = goals.count
    let todoCount = todolist.count
    var todosCompleted = 0
    let completedToDoCount = goals.map { (goal) -> Int in
      todosCompleted +=
        goal.todos.filter { (todo) -> Bool in
          todo.todoCompleted == true
        }.count
      return todosCompleted
    }.last
    
    let completeTodos = todolist.filter { (todo) -> Bool in
      todo.todoCompleted == true
    }.count
    
    let completedGoalCount = goals.filter { (goal) -> Bool in
      goal.goalCompleted == true
    }.count
    
    print("Goal Count: \(goalCount)")
    print("Todo Count: \(todoCount)")
    print("Completed Goal count: \(completedGoalCount)")
    print("Completed ToDo count: \(completedToDoCount ?? 0)")
    print("Completed ToDo count(2): \(completeTodos)")
    
    //    if fetchedGoalResultsController == nil {
    //      fetchedGoalResultsController = CoreDataController.shared.fetchedGoalResultsController
    //    }
  }
  
  //MARK: - Setup Data Array for History View
  func setupGroupSubSections() {
    
    let goalExp = NSExpression(forKeyPath: \Goal.goal ) // #keyPath(Goal.goal)
    let goalDateCreatedExp = NSExpression(forKeyPath: \Goal.goalDateCreated)
    let goalDateCompletedExp = NSExpression(forKeyPath: \Goal.goalDateCompleted)
    let goalCompletedExp = NSExpression(forKeyPath: \Goal.goalCompleted)
    let goalCountExp = NSExpression(forFunction: "count:", arguments: [goalExp])
    
    let goalDesc = NSExpressionDescription()
    goalDesc.name = "goal"
    goalDesc.expression = goalExp
    goalDesc.expressionResultType = .stringAttributeType
    
    let goalDateCreatedDesc = NSExpressionDescription()
    goalDateCreatedDesc.name = "goalCreated"
    goalDateCreatedDesc.expression = goalDateCreatedExp
    goalDateCreatedDesc.expressionResultType = .dateAttributeType
    
    let goalDateCompletedDesc = NSExpressionDescription()
    goalDateCompletedDesc.name = "goalCompleted"
    goalDateCompletedDesc.expression = goalDateCompletedExp
    goalDateCompletedDesc.expressionResultType = .dateAttributeType
    
    let goalCompletedDesc = NSExpressionDescription()
    goalCompletedDesc.name = "goalComplete"
    goalCompletedDesc.expression = goalCompletedExp
    goalCompletedDesc.expressionResultType = .stringAttributeType
    
    let goalCountDesc = NSExpressionDescription()
    goalCountDesc.name = "goalCount"
    goalCountDesc.expression = goalCountExp
    goalCountDesc.expressionResultType = .integer16AttributeType
    
    
    let sortDateDesc = NSSortDescriptor(keyPath: \Goal.goalDateCreated, ascending: false)
    
    let request = NSFetchRequest<NSDictionary>(entityName: "Goal")
    request.resultType = .dictionaryResultType
    request.propertiesToFetch = [goalCompletedDesc, goalDateCompletedDesc, goalDateCreatedDesc, goalDesc]
    //   request.propertiesToFetch = [goalCountDesc]
    //   request.propertiesToGroupBy = [goalDateCreatedDesc]
    request.sortDescriptors = [sortDateDesc]
    request.returnsObjectsAsFaults = false
    
    let todoExp = NSExpression(forKeyPath: \ToDo.todo)
    let todoCountExp = NSExpression(forFunction: "count:", arguments: [todoExp])
    
    let countTodoDateAdded = NSExpressionDescription()
    countTodoDateAdded.expression = todoCountExp
    countTodoDateAdded.name = "todoCount"
    countTodoDateAdded.expressionResultType = .integer16AttributeType
    
    do {
      let goalFetch = try CoreDataController.shared.managedContext.fetch(request)
      print(goalFetch)
    } catch {
      NSLog("Error fetching entity: %@", error.localizedDescription)
    }
  }
  
  func setupToDoSubSections() {
    
    let todoExp = NSExpression(forKeyPath: \ToDo.todo )
    let goalExp = NSExpression(forKeyPath: \ToDo.goal.goal)
    let todoDateCreatedExp = NSExpression(forKeyPath: \ToDo.todoDateCreated)
    let todoDateCompletedExp = NSExpression(forKeyPath: \ToDo.todoDateCompleted)
    let todoCompletedExp = NSExpression(forKeyPath: \ToDo.todoCompleted)
    let todoCountExp = NSExpression(forFunction: "count:", arguments: [todoCompletedExp])
    let count = NSExpression(format: "count:(todoDateCreated)")
    
    let todoDesc = NSExpressionDescription()
    todoDesc.name = "todo"
    todoDesc.expression = todoExp
    todoDesc.expressionResultType = .stringAttributeType
    
    let goalDesc = NSExpressionDescription()
    goalDesc.name = "goal"
    goalDesc.expression = goalExp
    goalDesc.expressionResultType = .stringAttributeType
    
    let todoDateCreatedDesc = NSExpressionDescription()
    todoDateCreatedDesc.name = "todoCreated"
    todoDateCreatedDesc.expression = todoDateCreatedExp
    todoDateCreatedDesc.expressionResultType = .dateAttributeType
    
    let todoDateCompletedDesc = NSExpressionDescription()
    todoDateCompletedDesc.name = "todoCompleted"
    todoDateCompletedDesc.expression = todoDateCompletedExp
    todoDateCompletedDesc.expressionResultType = .dateAttributeType
    
    let todoCompletedDesc = NSExpressionDescription()
    todoCompletedDesc.name = "todoComplete"
    todoCompletedDesc.expression = todoCompletedExp
    todoCompletedDesc.expressionResultType = .stringAttributeType
    
    let todoCountDesc = NSExpressionDescription()
    todoCountDesc.name = "todoCountAtDate"
    todoCountDesc.expression = todoCountExp
    todoCountDesc.expressionResultType = .integer16AttributeType
    
    let todoCount = NSExpressionDescription()
    todoCount.name = "todoCountDateCreated"
    todoCount.expression = count
    todoCount.expressionResultType = .integer16AttributeType
    
    let sortDateDesc = NSSortDescriptor(keyPath: \ToDo.todoDateCreated, ascending: false)
    
    let request = NSFetchRequest<NSDictionary>(entityName: "ToDo")
    //    request.resultType = .managedObjectResultType
    request.resultType = .dictionaryResultType
    request.propertiesToGroupBy = [#keyPath(ToDo.goal.goal), #keyPath(ToDo.todo)]
    request.propertiesToFetch = [goalDesc, todoDesc]// [#keyPath(ToDo.goal.goal), #keyPath(ToDo.todo)]
    
    request.sortDescriptors = [sortDateDesc]
    //    request.returnsObjectsAsFaults = false
    var todoFetch: [[String: String]]?
    do {
      todoFetch = try CoreDataController.shared.managedContext.fetch(request) as? [[String: String]]
      let result = try CoreDataController.shared.managedContext.fetch(request)
      
      print(todoFetch!)
      print(todoFetch!.count)
      
      print(result)
      print(result.count)
    } catch {
      NSLog("Error fetching entity: %@", error.localizedDescription)
    }
  }
  
  //MARK: - Goal and Todo Counts
  func populateCounts() {
    
    //MARK: - Total Counts
    guard let allGoalCount = getEntityCount(for: "Goal", with: allGoalPredicate) else { return }
    guard let allItemCount = getEntityCount(for: "ToDo", with: allToDoPredicate) else { return }
    
    guard let doneGoalCount = getEntityCount(for: "Goal", with: goalCompletedPredicate) else { return }
    guard let doneItemCount = getEntityCount(for: "ToDo", with: todoCompletedPredicate) else { return }


    //MARK: - Year Counts
    guard let yearGoalCount = getEntityCount(for: "Goal", with: pastYearGoalPredicate) else { return }
    guard let yearItemCount = getEntityCount(for: "ToDo", with: pastYearToDoPredicate) else { return }
    
    let yearGoalCompletedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [pastYearGoalPredicate, goalCompletedPredicate])
    let yearItemCompletedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [pastYearToDoPredicate, todoCompletedPredicate])
    
    guard let doneYearGoalCount = getEntityCount(for: "Goal", with: yearGoalCompletedPredicate) else { return }
    guard let doneYearItemCount = getEntityCount(for: "ToDo", with: yearItemCompletedPredicate) else { return }

    //MARK: - 6 Month Counts
    guard let sixMonthGoalCount = getEntityCount(for: "Goal", with: past6MonthGoalPredicate) else { return }
    guard let sixMonthItemCount = getEntityCount(for: "ToDo", with: past6MonthToDoPredicate) else { return }
    
    let sixMonthGoalCompletedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [past6MonthGoalPredicate, goalCompletedPredicate])
    let sixMonthItemCompletedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [past6MonthToDoPredicate, todoCompletedPredicate])
    
    guard let done6MonthGoalCount = getEntityCount(for: "Goal", with: sixMonthGoalCompletedPredicate) else { return }
    guard let done6MonthItemCount = getEntityCount(for: "ToDo", with: sixMonthItemCompletedPredicate) else { return }
    
    
    //MARK: - Month Counts
    guard let monthGoalCount = getEntityCount(for: "Goal", with: pastMonthGoalPredicate) else { return }
    guard let monthItemCount = getEntityCount(for: "ToDo", with: pastMonthToDoPredicate) else { return }
    
    let monthGoalCompletedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [pastMonthGoalPredicate, goalCompletedPredicate])
    let monthItemCompletedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [pastMonthToDoPredicate, todoCompletedPredicate])
    
    guard let doneMonthGoalCount = getEntityCount(for: "Goal", with: monthGoalCompletedPredicate) else { return }
    guard let doneMonthItemCount = getEntityCount(for: "ToDo", with: monthItemCompletedPredicate) else { return }

    print("allGoalCount        \(allGoalCount)")
    print("allItemCount        \(allItemCount)")
    print("doneGoalCount       \(doneGoalCount)")
    print("doneItemCount       \(doneItemCount)")

    print("yearGoalCount       \(yearGoalCount)")
    print("yearItemCount       \(yearItemCount)")
    print("doneYearGoalCount   \(doneYearGoalCount)")
    print("doneYearItemCount   \(doneYearItemCount)")

    print("sixMonthGoalCount   \(sixMonthGoalCount)")
    print("sixMonthItemCount   \(sixMonthItemCount)")
    print("done6MonthGoalCount \(done6MonthGoalCount)")
    print("done6MonthItemCount \(done6MonthItemCount)")
    print("monthGoalCount      \(monthGoalCount )")
    print("monthItemCount      \(monthItemCount )")
    print("doneMonthGoalCount  \(doneMonthGoalCount )")
    print("doneMonthItemCount  \(doneMonthItemCount )")

  }
  
  // Typical Count Case
  func getEntityCount(for entityName: String, with predicate: NSPredicate) -> Int? {
    let fetchRequest = NSFetchRequest<NSNumber>(entityName: entityName)
    
    fetchRequest.predicate = nil
    fetchRequest.fetchLimit = 0
    
    fetchRequest.resultType = .countResultType
    fetchRequest.predicate = predicate
    
    do {
      let countResult = try CoreDataController.shared.managedContext.fetch(fetchRequest)
      return countResult.first!.intValue
    } catch let error as NSError {
      print("count not fetched \(error), \(error.userInfo)")
      return nil
    }
  }
  
  func setupByMonthController() {

//    fetchedToDoResultsController.delegate = self
//    fetchedGoalResultsController.delegate = self
//    fetchedToDoResultsController.fetchRequest.predicate = allToDoPredicate
//    fetchedGoalResultsController.fetchRequest.predicate = allGoalPredicate
    
    fetchedToDoAllResultsController.delegate = self
    fetchedGoalAllResultsController.delegate = self
//    fetchedToDoAllResultsController.fetchRequest.predicate = todoCompletedPredicate
//    fetchedGoalAllResultsController.fetchRequest.predicate = goalCompletedPredicate
    fetchedToDoAllResultsController.fetchRequest.predicate = allToDoPredicate
    fetchedGoalAllResultsController.fetchRequest.predicate = allGoalPredicate
//
//    fetchedToDoYearResultsController.delegate = self
//    fetchedGoalYearResultsController.delegate = self
//    fetchedToDoYearResultsController.fetchRequest.predicate = todoCompletedPredicate
//    fetchedGoalYearResultsController.fetchRequest.predicate = goalCompletedPredicate
//
//    fetchedToDoMonthResultsController.delegate = self
//    fetchedGoalMonthResultsController.delegate = self
//    fetchedToDoMonthResultsController.fetchRequest.predicate = todoCompletedPredicate
//    fetchedGoalMonthResultsController.fetchRequest.predicate = goalCompletedPredicate
//
//    fetchedToDoWeekResultsController.delegate = self
//    fetchedGoalWeekResultsController.delegate = self
//    fetchedToDoWeekResultsController.fetchRequest.predicate = todoCompletedPredicate
//    fetchedGoalWeekResultsController.fetchRequest.predicate = goalCompletedPredicate

    frc1 = fetchedToDoAllResultsController
    frc2 = fetchedGoalAllResultsController
    
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
    
    let todoSections = frc1.sections
    let todoSectionCount = todoSections?.count
    let todos = frc1.fetchedObjects
    let todosCount = todos?.count
    print("frc1.sections: \(todoSections)")
    print("todoSectionCount: \(todoSectionCount ?? 0)")
    print("frc1.todos: \(todos)")
    print("todosCount: \(todosCount ?? 0)")
    
    let goalSections = frc2.sections
    let goalSectionCount = goalSections?.count
    let goals = frc2.fetchedObjects
    let goalsCount = goals?.count
    print("frc2.sections: \(goalSections)")
    print("goalSectionCount: \(goalSectionCount ?? 0)")
    print("frc2.todos: \(goals)")
    print("goalsCount: \(goalsCount ?? 0)")
  }
}

/*
 allGoalPredicate
 pastDayGoalPredicate
 pastWeekGoalPredicate
 pastMonthGoalPredicate
 past6MonthGoalPredicate
 pastYearGoalPredicate
 goalCompletedPredicate
 goalByMonthPredicate
 
 allToDoPredicate
 pastDayToDoPredicate
 pastWeekToDoPredicate
 pastMonthToDoPredicate
 past6MonthToDoPredicate
 pastYearToDoPredicate
 todoCompletedPredicate
 todoByMonthPredicate
 */
