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
    let context = persistentContainer.viewContext
    let request = ToDo.todoFetchRequest()
    let goalSort = NSSortDescriptor(keyPath: \ToDo.goal.goal, ascending: true)
    let createdSort = NSSortDescriptor(keyPath: \ToDo.todoDateCreated, ascending: false)
    request.sortDescriptors = [goalSort, createdSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: context,
      sectionNameKeyPath: #keyPath(Goal.goal),
      cacheName: nil)
    return fetchedResultsController
  }()
  
  lazy var fetchedGoalResultsController: NSFetchedResultsController<Goal> = {
    let context = persistentContainer.viewContext
    let request = Goal.goalFetchRequest()
    let goalSort = NSSortDescriptor(keyPath: \Goal.goal, ascending: true)
    let createdSort = NSSortDescriptor(keyPath: \Goal.goalDateCreated, ascending: false)
    request.sortDescriptors = [goalSort, createdSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: context,
      sectionNameKeyPath: #keyPath(Goal.goal),
      cacheName: nil)
    return fetchedResultsController
  }()
  
  lazy var fetchedToDoByYearController: NSFetchedResultsController<ToDo> = {
    let context = persistentContainer.viewContext
    let request = ToDo.todoFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \ToDo.todoDateCreated, ascending: false)
    request.sortDescriptors = [createdSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: context,
      sectionNameKeyPath: "groupByYear",
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
  lazy var fetchedGoalByYearController: NSFetchedResultsController<Goal> = {
    let context = persistentContainer.viewContext
    let request = Goal.goalFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \Goal.goalDateCreated, ascending: false)
    request.sortDescriptors = [createdSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: context,
      sectionNameKeyPath: "groupByYear",
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
  lazy var fetchedToDoByMonthController: NSFetchedResultsController<ToDo> = {
    let context = persistentContainer.viewContext
    let request = ToDo.todoFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \ToDo.todoDateCreated, ascending: false)
    request.sortDescriptors = [createdSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: context,
      sectionNameKeyPath: "groupByMonth",
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
  lazy var fetchedGoalByMonthController: NSFetchedResultsController<Goal> = {
    let context = persistentContainer.viewContext
    let request = Goal.goalFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \Goal.goalDateCreated, ascending: false)
    request.sortDescriptors = [createdSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: context,
      sectionNameKeyPath: "groupByMonth",
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
  lazy var fetchedToDoByWeekController: NSFetchedResultsController<ToDo> = {
    let context = persistentContainer.viewContext
    let request = ToDo.todoFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \ToDo.todoDateCreated, ascending: false)
    request.sortDescriptors = [createdSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: context,
      sectionNameKeyPath: "groupByWeek",
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
  lazy var fetchedGoalByWeekController: NSFetchedResultsController<Goal> = {
    let context = persistentContainer.viewContext
    let request = Goal.goalFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \Goal.goalDateCreated, ascending: false)
    request.sortDescriptors = [createdSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: context,
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
    
    // Goal 10
    let goal10 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal10.goal = "Tenth Goal"
    goal10.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*374)
    goal10.goalCompleted = false
    
    let todo28 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo28.todo = "Goal 10, To Do 1"
    todo28.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*374)
    todo28.todoCompleted = false
    todo28.id = UUID()
    todo28.goal = goal10
    
    
    let todo29 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo29.todo = "Goal 10, To Do 2"
    todo29.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*374)
    todo29.todoCompleted = false
    todo29.id = UUID()
    todo29.goal = goal10
    
    
    let todo30 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo30.todo = "Goal 10, To Do 3"
    todo30.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*374)
    todo30.todoCompleted = true
    todo30.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*373)
    todo30.id = UUID()
    todo30.goal = goal10
    
    
    // Goal 9
    let goal9 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal9.goal = "Nineth Goal"
    goal9.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*370)
    goal9.goalCompleted = false
    
    let todo25 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo25.todo = "Goal 9, To Do 1"
    todo25.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*370)
    todo25.todoCompleted = false
    todo25.id = UUID()
    todo25.goal = goal9
    
    let todo26 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo26.todo = "Goal 9, To Do 2"
    todo26.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*370)
    todo26.todoCompleted = true
    todo26.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*368)
    todo26.id = UUID()
    todo26.goal = goal9
    
    let todo27 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo27.todo = "Goal 9, To Do 3"
    todo27.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*370)
    todo27.todoCompleted = false
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
    todo22.todoCompleted = false
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
    goal5.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*32)
    goal5.goalCompleted = false
    
    let todo13 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo13.todo = "Goal 5, To Do 1"
    todo13.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*32)
    todo13.todoCompleted = false
    todo13.id = UUID()
    todo13.goal = goal5
    
    let todo14 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo14.todo = "Goal 5, To Do 2"
    todo14.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*32)
    todo14.todoCompleted = false
    todo14.id = UUID()
    todo14.goal = goal5
    
    let todo15 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo15.todo = "Goal 5, To Do 3"
    todo15.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*32)
    todo15.todoCompleted = false
    todo15.id = UUID()
    todo15.goal = goal5
    
    // Goal 4
    let goal4 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal4.goal = "Fourth Goal"
    goal4.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*16)
    goal4.goalCompleted = false
    
    let todo1 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo1.todo = "Goal 4, To Do 1"
    todo1.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*16)
    todo1.todoCompleted = false
    todo1.id = UUID()
    todo1.goal = goal4
    
    let todo2 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo2.todo = "Goal 4, To Do 2"
    todo2.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*16)
    todo2.todoCompleted = false
    todo2.id = UUID()
    todo2.goal = goal4
    
    let todo3 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo3.todo = "Goal 4, To Do 3"
    todo3.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*16)
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
    todo5.id = UUID()
    todo5.goal = goal3
    
    let todo6 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo6.todo = "Goal 3, To Do 3"
    todo6.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*19)
    todo6.todoCompleted = true
    todo6.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*8)
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
    todo9.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*8)
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
    todo11.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*3)
    todo11.todoCompleted = false
    todo11.id = UUID()
    todo11.goal = goal1
    
    let todo12 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo12.todo = "Goal 1, To Do 3"
    todo12.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*2)
    todo12.todoCompleted = false
    todo12.id = UUID()
    todo12.goal = goal1
    
    saveContext()
  }
}
