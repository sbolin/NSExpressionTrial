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

  var groupedResults = [[ResultGroup]]()
  var ungroupedResults = [ResultGroup]()
  var resultDict = [String: Any]()

  
  var todoRowsInSection: Int?
  var goalRowsInSection: Int?
  
  // date components
  // Calendar.current gives us access to a calendar that’s
  // configured according to the user’s system settings:
  let calendar = Calendar.current
  let date = Date()
  // end date components
    
  //MARK:- IBOutlets
  @IBOutlet weak var todayTableView: UITableView!
  
  //MARK: - FRC
  /*
  var fetchedToDoByYearResultsController = CoreDataController.shared.fetchedToDoByYearController
  var fetchedToDoByMonthResultsController = CoreDataController.shared.fetchedToDoByMonthController
  var fetchedToDoByWeekResultsController = CoreDataController.shared.fetchedToDoByWeekController
  var fetchedToDoResultsController = CoreDataController.shared.fetchedToDoResultsController
  var fetchedToDoResultsController = CoreDataController.shared.fetchedToDoResultsController
  
  var fetchedGoalByYearResultsController = CoreDataController.shared.fetchedGoalByYearController
  var fetchedGoalByMonthResultsController = CoreDataController.shared.fetchedGoalByMonthController
  var fetchedGoalByWeekResultsController = CoreDataController.shared.fetchedGoalByWeekController
  var fetchedGoalResultsController = CoreDataController.shared.fetchedGoalResultsController
  var fetchedGoalResultsController = CoreDataController.shared.fetchedGoalResultsController
  */
 
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
    CoreDataController.shared.createToDosIfNeeded()
    todayTableView.delegate = self
    todayTableView.dataSource = self
    
//    todayTableView.register(UITableViewCell.self, forCellReuseIdentifier: "GoalCell")
//    todayTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ToDoCell")
    
    
    setupToDoTableView()
//    setupGoalSubSections()
    setupToDoSubSections()
    populateCounts()
//    setupByMonthController()  // removed to new viewcontroller
    todayTableView.reloadData()
    
  }
  
  //MARK: 1. setupToDoTableView
  func setupToDoTableView() {
    print("\n\n 1. setupToDoTableView - get counts using fetch and filter results\n")

    // temp
    let goalFetch: NSFetchRequest = Goal.goalFetchRequest()
    let todoFetch: NSFetchRequest = ToDo.todoFetchRequest()
    
    // add in time predicate
    // filter by date
    var startComponents = DateComponents()
    startComponents.year = 2019
    startComponents.month = 6
    startComponents.day = 1
    startComponents.hour = 0
    startComponents.minute = 0
    let startDate = Calendar.current.date(from: startComponents) ?? Date()
    
    var endComponents = DateComponents()
    endComponents.year = 2020
    endComponents.month = 7
    endComponents.day = 31
    endComponents.hour = 23
    endComponents.minute = 59
    let endDate = Calendar.current.date(from: endComponents) ?? Date()
    
    let goalPredicate = NSPredicate(format: "%K BETWEEN {%@, %@}", #keyPath(Goal.goalDateCreated), startDate as CVarArg, endDate as CVarArg)
    
    let todoPredicate = NSPredicate(format: "%K BETWEEN {%@, %@}", #keyPath(ToDo.goal.goalDateCreated), startDate as CVarArg, endDate as CVarArg)
    
    goalFetch.predicate = goalPredicate
    todoFetch.predicate = todoPredicate
    
    // end filter by date
    
    
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
    
    let incompleteGoalCount = goalCount - completedGoalCount
    let incompleteToDoCount = todoCount - completeTodos
    
    print("Counts from NSFetchRequest with result filtered")
    print("Goal Count: \(goalCount)")
    print("Todo Count: \(todoCount)")
    print("Completed Goal count: \(completedGoalCount)")
    print("Incomplete Goal count: \(incompleteGoalCount)")
    print("Completed ToDo count: \(completedToDoCount ?? 0)")
    print("Completed ToDo count(2): \(completeTodos)")
    print("Incompleted ToDo count: \(incompleteToDoCount)")
    print("\n\n")
    
  }
    
  //MARK: 2. setupGoalSubSections
  func setupGoalSubSections() {
    print("\n\n 2. setupGoalSubSections - get counts using expressions on Goal entity\n")

    
    //    let goalByMonthExp = NSExpression(forVariable: #keyPath(Goal.groupByMonth))
    //    let goalByMonthExp = NSExpression(format: "function(%@, 'monthGrouping')", \Goal.goalDateCreated)
    
    let goalExp = NSExpression(forKeyPath: \Goal.goal ) // #keyPath(Goal.goal)
    let goalDateCreatedExp = NSExpression(forKeyPath: \Goal.goalDateCreated)
    let goalDateCompletedExp = NSExpression(forKeyPath: \Goal.goalDateCompleted)
    let goalCompletedExp = NSExpression(forKeyPath: \Goal.goalCompleted)
    let todos = NSExpression(forKeyPath: \Goal.todos)
    let todosExp = NSExpression(forAggregate: [todos])

    
    //    let goalSumExp = NSExpression(forFunction: "sum:", arguments: [goalExp])
    let goalDiffExp = NSExpression(format: "goalDateCompleted - goalDateCreated")
    let goalCreatedSum = NSExpression(forFunction: "sum:", arguments: [goalDateCreatedExp])
    let goalCompletedSum = NSExpression(forFunction: "sum:", arguments: [goalDateCompletedExp])
    let goalMinDate = NSExpression(forFunction: "min:", arguments: [goalDateCreatedExp])
    let goalMaxDate = NSExpression(forFunction: "max:", arguments: [goalDateCompletedExp])
    let goalCountExp = NSExpression(forFunction: "count:", arguments: [goalCompletedExp])
    
//    let todosCountExp = NSExpression(forFunction: "count:", arguments: [todosExp])

    
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
    goalCountDesc.name = "goalCompletedCount"
    goalCountDesc.expression = goalCountExp
    goalCountDesc.expressionResultType = .integer16AttributeType
    
    //    let goalSumDesc = NSExpressionDescription()
    //    goalSumDesc.name = "goalSum"
    //    goalSumDesc.expression = goalSumExp
    //    goalSumDesc.expressionResultType = .integer16AttributeType
    
    let goalDurationDesc = NSExpressionDescription()
    goalDurationDesc.name = "goalDuration"
    goalDurationDesc.expression = goalDiffExp
    goalDurationDesc.expressionResultType = .integer16AttributeType
    
    let goalCreatedSumDesc = NSExpressionDescription()
    goalCreatedSumDesc.name = "goalCreatedSum"
    goalCreatedSumDesc.expression = goalCreatedSum
    goalCreatedSumDesc.expressionResultType = .integer16AttributeType
    
    let goalCompletedSumDesc = NSExpressionDescription()
    goalCompletedSumDesc.name = "goalCompletedSum"
    goalCompletedSumDesc.expression = goalCompletedSum
    goalCompletedSumDesc.expressionResultType = .integer16AttributeType
    
    let goalMinDateDesc = NSExpressionDescription()
    goalMinDateDesc.name = "goalMinDate"
    goalMinDateDesc.expression = goalMinDate
    goalMinDateDesc.expressionResultType = .dateAttributeType
    
    let goalMaxDateDesc = NSExpressionDescription()
    goalMaxDateDesc.name = "goalMaxDate"
    goalMaxDateDesc.expression = goalMaxDate
    goalMaxDateDesc.expressionResultType = .dateAttributeType
    
    let todoCountDesc = NSExpressionDescription()
    todoCountDesc.name = "todoUncompletedCount"
    let todoCountPredicate = NSPredicate(format: "$todo.todoCompleted == FALSE")
    todoCountDesc.expression = NSExpression(forSubquery: todosExp, usingIteratorVariable: "todo", predicate: todoCountPredicate)
    todoCountDesc.expressionResultType = .integer16AttributeType
    
    let todoCompletedCountDesc = NSExpressionDescription()
    todoCompletedCountDesc.name = "todoCompletedCount"
    let todoCompletedPredicate = NSPredicate(format: "$todo.todoCompleted == TRUE")
    todoCompletedCountDesc.expression = NSExpression(forSubquery: todosExp, usingIteratorVariable: "todo", predicate: todoCompletedPredicate)
    todoCompletedCountDesc.expressionResultType = .integer16AttributeType

    let sortDateDesc = NSSortDescriptor(keyPath: \Goal.goalDateCreated, ascending: false)
    
    let request = NSFetchRequest<NSDictionary>(entityName: "Goal")
    request.resultType = .dictionaryResultType
    //    request.propertiesToFetch = [goalCompletedDesc, goalDateCompletedDesc, goalDateCreatedDesc, goalDesc]
    //    request.propertiesToFetch = [goalCountDesc, goalSumDesc, goalDurationDesc, goalCreatedSumDesc, goalCompletedSumDesc, goalMinDateDesc, goalMaxDateDesc]
    
    request.propertiesToFetch = [goalDesc, goalCountDesc, goalCreatedSumDesc, goalCompletedSumDesc, goalMinDateDesc, goalMaxDateDesc, goalDurationDesc] // goalSumDesc, , , , goalCompletedDesc,
//    request.propertiesToFetch = [goalDateCreatedDesc, goalCountDesc]
//        request.propertiesToFetch = [todoCountDesc, todoCompletedCountDesc] // goalSumDesc, , , , goalCompletedDesc,
    request.propertiesToGroupBy = [goalDesc] // goalDateCreatedDesc
    request.sortDescriptors = [sortDateDesc]
    request.returnsObjectsAsFaults = false
    
    print("Goal Description, todo items")
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
  
  //MARK: 3. setupToDoSubSections
  func setupToDoSubSections() {
    
    print("\n\n 3. setupToDoSubSections - get counts using expressions on ToDo entity, create Struct dataSource for Tableview\n")
    
    let todoExp = NSExpression(forKeyPath: \ToDo.todo )
    let todoDateCreatedExp = NSExpression(forKeyPath: \ToDo.todoDateCreated)
    let todoDateCompletedExp = NSExpression(forKeyPath: \ToDo.todoDateCompleted)
    let todoCompleteExp = NSExpression(forKeyPath: \ToDo.todoCompleted)
    
    let goalExp = NSExpression(forKeyPath: \ToDo.goal.goal)
    let goalDateCreatedExp = NSExpression(forKeyPath: \ToDo.goal.goalDateCreated)
    let goalDateCompletedExp = NSExpression(forKeyPath: \ToDo.goal.goalDateCompleted)
    let goalDateCompleteExp = NSExpression(forKeyPath: \ToDo.goal.goalCompleted)

    let todoDiffExp = NSExpression(format: "todoDateCompleted - todoDateCreated")
    let todoMinDate = NSExpression(forFunction: "min:", arguments: [todoDateCreatedExp])
    let todoMaxDate = NSExpression(forFunction: "max:", arguments: [todoDateCompletedExp])
    let goalDiffExp = NSExpression(format: "goal.goalDateCompleted - goal.goalDateCreated")

//    let todoCreatedSum = NSExpression(forFunction: "sum:", arguments: [todoDateCreatedExp])
//    let todoCompletedSum = NSExpression(forFunction: "sum:", arguments: [todoDateCompletedExp])
//    let todoCountExp = NSExpression(forFunction: "count:", arguments: [todoCompletedExp])
    
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
    
    let goalDateCreatedDesc = NSExpressionDescription()
    goalDateCreatedDesc.name = "goalCreated"
    goalDateCreatedDesc.expression = goalDateCreatedExp
    goalDateCreatedDesc.expressionResultType = .dateAttributeType
    
    let goalDateCompletedDesc = NSExpressionDescription()
    goalDateCompletedDesc.name = "goalCompleted"
    goalDateCompletedDesc.expression = goalDateCompletedExp
    goalDateCompletedDesc.expressionResultType = .dateAttributeType
    
    let goalCompleteDesc = NSExpressionDescription()
    goalCompleteDesc.name = "goalComplete"
    goalCompleteDesc.expression = goalDateCompleteExp
    goalCompleteDesc.expressionResultType = .booleanAttributeType
    
    let todoCompleteDesc = NSExpressionDescription()
    todoCompleteDesc.name = "todoComplete"
    todoCompleteDesc.expression = todoCompleteExp
    todoCompleteDesc.expressionResultType = .booleanAttributeType
    
    //    let todoCount = NSExpressionDescription()
    //    todoCount.name = "todoCountDateCreated"
    //    todoCount.expression = count
    //    todoCount.expressionResultType = .integer16AttributeType
    
    let todoDurationDesc = NSExpressionDescription()
    todoDurationDesc.name = "todoDuration"
    todoDurationDesc.expression = todoDiffExp
    todoDurationDesc.expressionResultType = .integer64AttributeType // date difference
    
    let goalDurationDesc = NSExpressionDescription()
    goalDurationDesc.name = "goalDuration"
    goalDurationDesc.expression = goalDiffExp
    goalDurationDesc.expressionResultType = .integer64AttributeType // date difference
    
    let todoMinDateDesc = NSExpressionDescription()
    todoMinDateDesc.name = "todoMinDate"
    todoMinDateDesc.expression = todoMinDate
    todoMinDateDesc.expressionResultType = .dateAttributeType
    
    let todoMaxDateDesc = NSExpressionDescription()
    todoMaxDateDesc.name = "todoMaxDate"
    todoMaxDateDesc.expression = todoMaxDate
    todoMaxDateDesc.expressionResultType = .dateAttributeType
    
    let sortDateDesc = NSSortDescriptor(keyPath: \ToDo.goal.goalDateCreated, ascending: true)
    
    let request = NSFetchRequest<NSDictionary>(entityName: "ToDo")
    request.resultType = .dictionaryResultType
    request.propertiesToFetch = [goalDesc, todoDesc, goalDateCreatedDesc, goalDateCompletedDesc, goalCompleteDesc, todoDateCreatedDesc, todoDateCompletedDesc, todoCompleteDesc, todoMinDateDesc, todoMaxDateDesc, todoDurationDesc, goalDurationDesc]
    request.propertiesToGroupBy = [goalDesc, todoDesc, goalDateCreatedDesc, goalDateCompletedDesc, goalCompleteDesc, todoDateCreatedDesc, todoDateCompletedDesc, todoCompleteDesc]
    request.sortDescriptors = [sortDateDesc]
    request.returnsObjectsAsFaults = false
    
    do {
      let results = try CoreDataController.shared.managedContext.fetch(request)
            
      results.forEach { (result) in
        for (key, value) in result {
          resultDict[key as! String] = value
        }
        ungroupedResults.append(ResultGroup(dictInput: resultDict))
      }
    } catch {
      NSLog("Error fetching entity: %@", error.localizedDescription)
    }
    // group by month created, not by item created date
    let groupedDictionary = Dictionary(grouping: ungroupedResults) { (item) -> String in // Date in
//      return item.goalCreated
      return item.goalGroupByMonth
    }
    
    let keys = groupedDictionary.keys // .sorted()
    print("keys: \(keys)")

    keys.forEach({
      groupedResults.append(groupedDictionary[$0]!)
      })
      
    // TODO: sort groupedResults

    print("\n\ngroupedResults data:")
    print("sections: \(groupedResults.count)")
    for section in (0..<groupedResults.count) {
      for row in (0..<groupedResults[section].count) {
        print("section \(section), row \(row): \n\(groupedResults[section][row])")
      }
    }
    todayTableView.reloadData()
  }
  
  //MARK: 4. PopulateCounts Goal and Todo Counts
  func populateCounts() {
    print("\n\n 4. populateCounts - get counts using predicates\n")

    
    //MARK: Total Counts
    guard let allGoalCount = getEntityCount(for: "Goal", with: allGoalPredicate) else { return }
    guard let allItemCount = getEntityCount(for: "ToDo", with: allToDoPredicate) else { return }
    
    guard let doneGoalCount = getEntityCount(for: "Goal", with: goalCompletedPredicate) else { return }
    guard let doneItemCount = getEntityCount(for: "ToDo", with: todoCompletedPredicate) else { return }
    
    
    //MARK: Year Counts
    guard let yearGoalCount = getEntityCount(for: "Goal", with: pastYearGoalPredicate) else { return }
    guard let yearItemCount = getEntityCount(for: "ToDo", with: pastYearToDoPredicate) else { return }
    
    let yearGoalCompletedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [pastYearGoalPredicate, goalCompletedPredicate])
    let yearItemCompletedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [pastYearToDoPredicate, todoCompletedPredicate])
    
    guard let doneYearGoalCount = getEntityCount(for: "Goal", with: yearGoalCompletedPredicate) else { return }
    guard let doneYearItemCount = getEntityCount(for: "ToDo", with: yearItemCompletedPredicate) else { return }
    
    //MARK: 6 Month Counts
    guard let sixMonthGoalCount = getEntityCount(for: "Goal", with: past6MonthGoalPredicate) else { return }
    guard let sixMonthItemCount = getEntityCount(for: "ToDo", with: past6MonthToDoPredicate) else { return }
    
    let sixMonthGoalCompletedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [past6MonthGoalPredicate, goalCompletedPredicate])
    let sixMonthItemCompletedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [past6MonthToDoPredicate, todoCompletedPredicate])
    
    guard let done6MonthGoalCount = getEntityCount(for: "Goal", with: sixMonthGoalCompletedPredicate) else { return }
    guard let done6MonthItemCount = getEntityCount(for: "ToDo", with: sixMonthItemCompletedPredicate) else { return }
    
    
    //MARK: Month Counts
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
  
  func contentDidLoad(_ content: Goal) {
    let refreshDate = calendar.startOfDay(for: .currentTimeTomorrow)
    //    cache(content, until: refreshDate.addingTimeInterval(100)) // save current todo, check tomorrow if completed or not. If completed, add new Goal. Note: add 100s 'buffer' just in case
  }
}

extension Date {
  func sameTimeNextDay(
    inDirection direction: Calendar.SearchDirection = .forward,
    using calendar: Calendar = .current
  ) -> Date {
    let components = calendar.dateComponents(
      [.hour, .minute, .second, .nanosecond],
      from: self
    )
    
    return calendar.nextDate(
      after: self,
      matching: components,
      matchingPolicy: .nextTime,
      direction: direction
      )!
  }
  
  func sameTimeNextMonth(
    inDirection direction: Calendar.SearchDirection = .forward,
    using calendar: Calendar = .current
  ) -> Date {
    let components = calendar.dateComponents(
      [.day, .hour, .minute, .second, .nanosecond],  // nextDate return next month
      from: self
    )
    
    return calendar.nextDate(
      after: self,
      matching: components,
      matchingPolicy: .nextTime,
      direction: direction
      )!
  }
}

extension Date {
  static var currentTimeTomorrow: Date {
    return Date().sameTimeNextDay()
  }
  
  static var currentTimeYesterday: Date {
    return Date().sameTimeNextDay(inDirection: .backward)
  }
}

extension Date {
  static var currentTimeNextMonth: Date {
    return Date().sameTimeNextMonth()
  }
  
  static var currentTimeLastMonth: Date {
    return Date().sameTimeNextMonth(inDirection: .backward)
  }
}
