//
//  ResultGroup.swift
//  NSExpressionTrial
//
//  Created by Scott Bolin on 7/14/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import Foundation

struct ResultGroup {
  let goal: String
  let todo: String
  let todoCreated: Date
  let todoCompleted: Date
  let goalComplete: Bool
  let goalCreated: Date
  let goalCompleted: Date
  let todoComplete: Bool
  let todoCompletedSum: Int
  let todoMinDate: Date
  let todoMaxDate: Date
  let todoDuration: Int
  let goalDuration: Int
  
  var todoGroupByYear: String {
    get {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy"
      return dateFormatter.string(from: todoCreated)
    }
  }
  
  var todoGroupByMonth: String { // String {
    get {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMM yyyy"
      return dateFormatter.string(from: todoCreated)
    }
  }
  
  var todoGroupByWeek: String {
    get {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "w Y"
      return dateFormatter.string(from: todoCreated)
    }
  }
  
  var goalGroupByYear: String {
    get {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy"
      return dateFormatter.string(from: goalCreated)
    }
  }
  
  var goalGroupByMonth: String {
    get {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMM yyyy"
      return dateFormatter.string(from: goalCreated)
    }
  }
  
  var goalGroupByWeek: String {
    get {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "w Y"
      return dateFormatter.string(from: goalCreated)
    }
  }
  
  init(dictInput: [String: Any]) {
    self.goal = dictInput["goal"] as! String
    self.todo = dictInput["todo"] as! String
    self.todoCreated = dictInput["todoCreated"] as! Date
    self.todoCompleted = dictInput["todoCompleted"] as? Date ?? Date()
    self.goalComplete = dictInput["goalComplete"] as! Bool
    self.goalCreated = dictInput["goalCreated"] as! Date
    self.goalCompleted = dictInput["goalCompleted"] as? Date ?? Date()
    self.todoComplete = dictInput["todoComplete"] as! Bool
    self.todoCompletedSum = dictInput["todoCompletedSum"] as? Int ?? 0
    self.todoMinDate = dictInput["todoMinDate"] as! Date
    self.todoMaxDate = dictInput["todoMaxDate"] as! Date
    self.todoDuration = dictInput["todoDuration"] as? Int ?? 0
    self.goalDuration = dictInput["goalDuration"] as? Int ?? 0
  }
}
