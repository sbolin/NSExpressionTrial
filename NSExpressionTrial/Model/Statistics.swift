//
//  Statistics.swift
//  NSExpressionTrial
//
//  Created by Scott Bolin on 7/16/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import Foundation

struct Statistics {
  var todoCount: [Int]
  var todoComplete: [Int]
  var todoIncomplete: [Int]
  var todoDuration: [Int]
  var goalCount: [Int]
  var goalComplete: [Int]
  var goalIncomplete: [Int]
  var goalDuration: [Int]
  
  init() {
    todoCount = []
    todoComplete = []
    todoIncomplete = []
    todoDuration = []
    goalCount = []
    goalComplete = []
    goalIncomplete = []
    goalDuration = []
  }
}
