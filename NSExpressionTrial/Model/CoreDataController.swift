//
//  CoreDataController.swift
//  NSExpressionTrial
//
//  Created by Scott Bolin on 6/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataController {
  
  //MARK: - Create CoreData Stack
  static let shared = CoreDataController() // singleton
  private init() {} // Prevent creating another instance.
  
  lazy var managedContext: NSManagedObjectContext = {
    return self.persistentContainer.viewContext
  }()
  
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Focus")
    container.loadPersistentStores { (storeDescription, error) in
      container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
      if let error = error as NSError? {
        print("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  //MARK: - FetchedResultsControllers
  lazy var fetchedToDoResultsController: NSFetchedResultsController<ToDo> = {
    let managedContext = persistentContainer.viewContext
    let request = ToDo.todoFetchRequest()
    let goalSort = NSSortDescriptor(keyPath: \ToDo.goal.goal, ascending: true)
    let createdSort = NSSortDescriptor(keyPath: \ToDo.goal.goalDateCreated, ascending: true)
    let idSort = NSSortDescriptor(keyPath: \ToDo.id, ascending: true)
    request.sortDescriptors = [createdSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: managedContext,
      sectionNameKeyPath: #keyPath(ToDo.goal.goalDateCreated),
      cacheName: nil)
    return fetchedResultsController
  }()
  
  lazy var fetchedGoalResultsController: NSFetchedResultsController<Goal> = {
    let managedContext = persistentContainer.viewContext
    let request = Goal.goalFetchRequest()
    let goalSort = NSSortDescriptor(keyPath: \Goal.goal, ascending: true)
    let createdSort = NSSortDescriptor(keyPath: \Goal.goalDateCreated, ascending: false)
    request.sortDescriptors = [createdSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: managedContext,
      sectionNameKeyPath: #keyPath(Goal.goalDateCreated),
      cacheName: nil)
    return fetchedResultsController
  }()
  
  lazy var fetchedToDoByYearController: NSFetchedResultsController<ToDo> = {
    let managedContext = persistentContainer.viewContext
    let request = ToDo.todoFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \ToDo.todoDateCreated, ascending: true)
    let idSort = NSSortDescriptor(keyPath: \ToDo.id, ascending: true)
    request.sortDescriptors = [createdSort, idSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: managedContext,
      sectionNameKeyPath: "groupByYear",
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
  lazy var fetchedGoalByYearController: NSFetchedResultsController<Goal> = {
    let managedContext = persistentContainer.viewContext
    let request = Goal.goalFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \Goal.goalDateCreated, ascending: true)
    request.sortDescriptors = [createdSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: managedContext,
      sectionNameKeyPath: "groupByYear",
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
  lazy var fetchedToDoByMonthController: NSFetchedResultsController<ToDo> = {
    let managedContext = persistentContainer.viewContext
    let request = ToDo.todoFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \ToDo.todoDateCreated, ascending: true)
    let idSort = NSSortDescriptor(keyPath: \ToDo.id, ascending: true)
    request.sortDescriptors = [createdSort, idSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: managedContext,
      sectionNameKeyPath: "groupByMonth",
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
  lazy var fetchedGoalByMonthController: NSFetchedResultsController<Goal> = {
    let managedContext = persistentContainer.viewContext
    let request = Goal.goalFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \Goal.goalDateCreated, ascending: true)
    request.sortDescriptors = [createdSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: managedContext,
      sectionNameKeyPath: "groupByMonth",
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
  lazy var fetchedToDoByWeekController: NSFetchedResultsController<ToDo> = {
    let managedContext = persistentContainer.viewContext
    let request = ToDo.todoFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \ToDo.todoDateCreated, ascending: true)
    let idSort = NSSortDescriptor(keyPath: \ToDo.id, ascending: true)
    request.sortDescriptors = [createdSort, idSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: managedContext,
      sectionNameKeyPath: "groupByWeek",
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
  lazy var fetchedGoalByWeekController: NSFetchedResultsController<Goal> = {
    let managedContext = persistentContainer.viewContext
    let request = Goal.goalFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \Goal.goalDateCreated, ascending: true)
    request.sortDescriptors = [createdSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: managedContext,
      sectionNameKeyPath: "groupByWeek",
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
  //MARK: - SaveContext
  func saveContext () {
    guard managedContext.hasChanges else { return }
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Unresolved error \(error), \(error.localizedDescription)")
    }
  }
  
  //MARK: - create todos
  func createToDosIfNeeded() {
    
    // check if todos exist, if so return
    let fetchRequest = Goal.goalFetchRequest()
    let count = try! managedContext.count(for: fetchRequest)
    
    guard count == 0 else { return }
    
    // Goal 12
    let goal12 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal12.goal = "Twelth Goal"
    goal12.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*377)
    goal12.goalDateCompleted = Date(timeIntervalSinceNow: -60*60*24*374)
    goal12.goalCompleted = true
    
    let todo34 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo34.todo = "Goal 12, To Do 1"
    todo34.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*377)
    todo34.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*376)
    todo34.todoCompleted = true
    todo34.id = UUID()
    todo34.goal = goal12
    
    let todo35 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo35.todo = "Goal 12, To Do 2"
    todo35.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*377)
    todo35.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*375)
    todo35.todoCompleted = true
    todo35.id = UUID()
    todo35.goal = goal12
    
    let todo36 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo36.todo = "Goal 12, To Do 3"
    todo36.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*377)
    todo36.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*374)
    todo36.todoCompleted = true
    todo36.id = UUID()
    todo36.goal = goal12
    
    // Goal 11
    let goal11 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal11.goal = "Eleventh Goal"
    goal11.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*376)
    goal11.goalDateCompleted = Date(timeIntervalSinceNow: -60*60*24*373)
    goal11.goalCompleted = true
    
    let todo31 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo31.todo = "Goal 11, To Do 1"
    todo31.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*376)
    todo31.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*375)
    todo31.todoCompleted = true
    todo31.id = UUID()
    todo31.goal = goal11
    
    let todo32 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo32.todo = "Goal 11, To Do 2"
    todo32.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*376)
    todo32.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*374)
    todo32.todoCompleted = true
    todo32.id = UUID()
    todo32.goal = goal11
    
    let todo33 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo33.todo = "Goal 11, To Do 3"
    todo33.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*376)
    todo33.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*373)
    todo33.todoCompleted = true
    todo33.id = UUID()
    todo33.goal = goal11
    
    // Goal 10
    let goal10 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal10.goal = "Tenth Goal"
    goal10.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*374)
    goal10.goalDateCompleted = Date(timeIntervalSinceNow: -60*60*24*371)
    goal10.goalCompleted = true
    
    let todo28 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo28.todo = "Goal 10, To Do 1"
    todo28.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*374)
    todo28.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*373)
    todo28.todoCompleted = true
    todo28.id = UUID()
    todo28.goal = goal10
    
    let todo29 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo29.todo = "Goal 10, To Do 2"
    todo29.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*374)
    todo29.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*372)
    todo29.todoCompleted = true
    todo29.id = UUID()
    todo29.goal = goal10
    
    let todo30 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo30.todo = "Goal 10, To Do 3"
    todo30.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*374)
    todo30.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*371)
    todo30.todoCompleted = true
    todo30.id = UUID()
    todo30.goal = goal10
    
    // Goal 9
    let goal9 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal9.goal = "Ninth Goal"
    goal9.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*370)
    goal9.goalDateCompleted = Date(timeIntervalSinceNow: -60*60*24*367)
    goal9.goalCompleted = true
    
    let todo25 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo25.todo = "Goal 9, To Do 1"
    todo25.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*370)
    todo25.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*369)
    todo25.todoCompleted = true
    todo25.id = UUID()
    todo25.goal = goal9
    
    let todo26 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo26.todo = "Goal 9, To Do 2"
    todo26.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*370)
    todo26.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*368)
    todo26.todoCompleted = true
    todo26.id = UUID()
    todo26.goal = goal9
    
    let todo27 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo27.todo = "Goal 9, To Do 3"
    todo27.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*370)
    todo27.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*367)
    todo27.todoCompleted = true
    todo27.id = UUID()
    todo27.goal = goal9
    
    // Goal 8
    let goal8 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal8.goal = "Eighth Goal"
    goal8.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*366)
    goal8.goalCompleted = false
    
    let todo22 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo22.todo = "Goal 8, To Do 1"
    todo22.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*366)
    todo22.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*365)
    todo22.todoCompleted = true
    todo22.id = UUID()
    todo22.goal = goal8
    
    let todo23 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo23.todo = "Goal 8, To Do 2"
    todo23.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*366)
    todo23.todoCompleted = false
    todo23.id = UUID()
    todo23.goal = goal8
    
    let todo24 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo24.todo = "Goal 8, To Do 3"
    todo24.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*366)
    todo24.todoCompleted = false
    todo24.id = UUID()
    todo24.goal = goal8
    
    // Goal 7
    let goal7 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal7.goal = "Seventh Goal"
    goal7.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*181)
    goal7.goalCompleted = false
    
    let todo19 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo19.todo = "Goal 7, To Do 1"
    todo19.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*181)
    todo19.todoCompleted = false
    todo19.id = UUID()
    todo19.goal = goal7
    
    let todo20 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo20.todo = "Goal 7, To Do 2"
    todo20.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*181)
    todo20.todoCompleted = false
    todo20.id = UUID()
    todo20.goal = goal7
    
    let todo21 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo21.todo = "Goal 7, To Do 3"
    todo21.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*181)
    todo21.todoCompleted = false
    todo21.id = UUID()
    todo21.goal = goal7
    
    // Goal 6
    let goal6 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal6.goal = "Sixth Goal"
    goal6.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*90)
    goal6.goalCompleted = false
    
    let todo16 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo16.todo = "Goal 6, To Do 1"
    todo16.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*90)
    todo16.todoCompleted = false
    todo16.id = UUID()
    todo16.goal = goal6
    
    let todo17 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo17.todo = "Goal 6, To Do 2"
    todo17.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*90)
    todo17.todoCompleted = false
    todo17.id = UUID()
    todo17.goal = goal6
    
    let todo18 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo18.todo = "Goal 6, To Do 3"
    todo18.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*90)
    todo18.todoCompleted = false
    todo18.id = UUID()
    todo18.goal = goal6
    
    // Goal 5
    let goal5 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal5.goal = "Fifth Goal"
    goal5.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*45)
    goal5.goalCompleted = false
    
    let todo13 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo13.todo = "Goal 5, To Do 1"
    todo13.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*45)
    todo13.todoCompleted = false
    todo13.id = UUID()
    todo13.goal = goal5
    
    let todo14 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo14.todo = "Goal 5, To Do 2"
    todo14.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*45)
    todo14.todoCompleted = false
    todo14.id = UUID()
    todo14.goal = goal5
    
    let todo15 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo15.todo = "Goal 5, To Do 3"
    todo15.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*45)
    todo15.todoCompleted = false
    todo15.id = UUID()
    todo15.goal = goal5
    
    // Goal 4
    let goal4 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal4.goal = "Fourth Goal"
    goal4.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*32)
    goal4.goalCompleted = false
    
    let todo1 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo1.todo = "Goal 4, To Do 1"
    todo1.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*32)
    todo1.todoCompleted = false
    todo1.id = UUID()
    todo1.goal = goal4
    
    let todo2 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo2.todo = "Goal 4, To Do 2"
    todo2.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*32)
    todo2.todoCompleted = false
    todo2.id = UUID()
    todo2.goal = goal4
    
    let todo3 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo3.todo = "Goal 4, To Do 3"
    todo3.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*32)
    todo3.todoCompleted = false
    todo3.id = UUID()
    todo3.goal = goal4
    
    // Goal 3
    let goal3 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal3.goal = "Third Goal"
    goal3.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*19)
    goal3.goalCompleted = false
    
    let todo4 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo4.todo = "Goal 3, To Do 1"
    todo4.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*19)
    todo4.todoCompleted = false
    todo4.id = UUID()
    todo4.goal = goal3
    
    let todo5 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo5.todo = "Goal 3, To Do 2"
    todo5.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*19)
    todo5.todoCompleted = true
    todo5.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*17)
    todo5.id = UUID()
    todo5.goal = goal3
    
    let todo6 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo6.todo = "Goal 3, To Do 3"
    todo6.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*19)
    todo6.todoCompleted = true
    todo6.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*16)
    todo6.id = UUID()
    todo6.goal = goal3
    
    // Goal 2
    let goal2 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal2.goal = "Second Goal"
    goal2.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*11)
    goal2.goalCompleted = true
    goal2.goalDateCompleted = Date(timeIntervalSinceNow: -60*60*24*8)
    
    let todo7 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo7.todo = "Goal 2, To Do 1"
    todo7.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*11)
    todo7.todoCompleted = true
    todo7.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*8)
    todo7.id = UUID()
    todo7.goal = goal2
    
    let todo8 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo8.todo = "Goal 2, To Do 2"
    todo8.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*11)
    todo8.todoCompleted = true
    todo8.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*9)
    todo8.id = UUID()
    todo8.goal = goal2
    
    let todo9 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo9.todo = "Goal 2, To Do 3"
    todo9.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*11)
    todo9.todoCompleted = true
    todo9.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*10)
    todo9.id = UUID()
    todo9.goal = goal2
    
    // Goal 1
    let goal1 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal1.goal = "First Goal"
    goal1.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*2)
    goal1.goalCompleted = false
    
    let todo10 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo10.todo = "Goal 1, To Do 1"
    todo10.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*2)
    todo10.todoCompleted = true
    todo10.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*1)
    todo10.id = UUID()
    todo10.goal = goal1
    
    let todo11 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo11.todo = "Goal 1, To Do 2"
    todo11.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*2)
    todo11.todoCompleted = false
    todo11.id = UUID()
    todo11.goal = goal1
    
    let todo12 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo12.todo = "Goal 1, To Do 3"
    todo12.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*2)
    todo12.todoCompleted = false
    todo12.id = UUID()
    todo12.goal = goal1
    
    // Goal 0
    let goal0 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal0.goal = "Zero Goal"
    goal0.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*1)
    goal0.goalCompleted = false
    
    let todo37 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo37.todo = "Goal 0, To Do 1"
    todo37.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*1)
    todo37.todoCompleted = true
    todo37.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*1)
    todo37.id = UUID()
    todo37.goal = goal0
    
    let todo38 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo38.todo = "Goal 0, To Do 2"
    todo38.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*1)
    todo38.todoCompleted = false
    todo38.id = UUID()
    todo38.goal = goal0
    
    let todo39 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo39.todo = "Goal 0, To Do 3"
    todo39.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*1)
    todo39.todoCompleted = false
    todo39.id = UUID()
    todo39.goal = goal0
    
    saveContext()
  }
}
