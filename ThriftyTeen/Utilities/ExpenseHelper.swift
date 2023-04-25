//
//  ExpenseHelper.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/5/23.
//

import Foundation

enum ExpensesHelper {
    static let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.minimumDaysInFirstWeek = 1
        calendar.firstWeekday = 1
        return calendar
    }()
    
    static func findMostSpentCategory(_ expenses: [Expense]) -> String {
        var categorySpendings = [String: Double]()
        
        for expense in expenses {
            categorySpendings[expense.category.title] = categorySpendings[expense.category.title, default: 0] + expense.amount
        }
        
        var mostSpentCategory = ""
        var mostSpentAmount = 0.0
        
        for (category, amount) in categorySpendings {
            if (amount > mostSpentAmount) {
                mostSpentCategory = category
                mostSpentAmount = amount
            }
        }
        
        return mostSpentCategory
    }
    
    static func calculateTotalSpent(_ expenses: [Expense]) -> Double {
        return expenses.reduce(0.0) { $0 + $1.amount }
    }
    
    static func getExpenseYears(_ expenses: [Expense]) -> [Int] {
        let years = expenses.map { calendar.component(.year, from: $0.date) }
        let yearsSet = Set(years)
        
        return Array(yearsSet).sorted { $0 > $1 }
    }
    
    static func getExpensesByYear(_ expenses: [Expense]) -> [Int: [Expense]] {
        return expenses.reduce(into: [Int: [Expense]]()) { result, expense in
            let year = calendar.component(.year, from: expense.date)
            result[year, default: []].append(expense)
        }
    }
    
    static func getExpensesByWeek(_ expenses: [Expense], year: Int) -> [WeekExpenseRange] {
        let firstDayComponents = DateComponents(year: year, month: 1, day: 1)
        let startDate = calendar.date(from: firstDayComponents)!
        
        let firstDayComponentsNextYear = DateComponents(year: year + 1, month: 1, day: 1)
        let nextYear = calendar.date(from: firstDayComponentsNextYear)!
        let endDate = calendar.date(byAdding: .day, value: -1, to: nextYear)
        
        guard let endDate else {
            return []
        }
        
        var weekRanges = [Int: WeekExpenseRange]()
        
        var scan = startDate
        while scan <= endDate {
            let currentWeekNumber = adjustedWeekNumber(date: scan)
            let defaultValue = WeekExpenseRange(weekStart: scan, weekEnd: scan, expenses: [])
            
            var currentWeekRange = weekRanges[currentWeekNumber, default: defaultValue]
            currentWeekRange.weekEnd = scan
            
            weekRanges[currentWeekNumber] = currentWeekRange
            
            scan = calendar.date(byAdding: .day, value: 1, to: scan)!
        }
        
        for expense in expenses {
            let weekNumber = adjustedWeekNumber(date: expense.date)
            weekRanges[weekNumber]?.expenses.append(expense)
        }
        
        let flattenedWeekRanges = Array(weekRanges.values)
            .sorted(by: { $0.weekStart < $1.weekStart })
        
        return flattenedWeekRanges
    }
    
    static func firstWeekNumber(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month, day: 1)
        let date = calendar.date(from: dateComponents)!
        
        return calendar.component(.weekOfYear, from: date)
    }
    
    static func monthNumber(year: Int, weekNumber: Int) -> Int {
        let dateComponents = DateComponents(weekOfYear: weekNumber, yearForWeekOfYear: year)
        
        let date = calendar.date(from: dateComponents)!
        let month = calendar.component(.month, from: date)
        
        return month
    }
    
    static func getExpensesByWeek(for expenses: [Expense], year: Int, month: Int) -> [WeekExpenseRange] {
        let dateComponents = DateComponents(year: year, month: month)
        
        guard let startDate = calendar.date(from: dateComponents),
              let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate) else {
            fatalError("Invalid date components")
        }
        
        var weekRanges = [Int: WeekExpenseRange]()
        
        calendar.enumerateDates(startingAfter: calendar.date(byAdding: .day, value: -1, to: startDate)!, matching: .init(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime) { date, _, stop in
            guard let currentDate = date else { return }

            if currentDate > endDate {
                stop = true
                return
            }
            
            let currentWeekNumber = calendar.component(.weekOfMonth, from: currentDate)
            var currentWeekRange = weekRanges[currentWeekNumber, default:
                                                WeekExpenseRange(weekStart: currentDate, weekEnd: currentDate, expenses: [])]
            
            currentWeekRange.weekEnd = currentDate
            weekRanges[currentWeekNumber] = currentWeekRange
        }
        
        for expense in expenses {
            let weekNumber = calendar.component(.weekOfMonth, from: expense.date)
            weekRanges[weekNumber]?.expenses.append(expense)
        }
        
        return Array(weekRanges.values)
            .sorted(by: { $0.weekStart < $1.weekStart })
    }
    
    static func getExpensesByMonth(for expenses: [Expense]) -> [Int: [Expense]] {
        let monthRange = calendar.range(of: .month, in: .year, for: Date())!
        
        let emptyExpenses = [Expense]()
        let initialDict = monthRange.reduce(into: [Int: [Expense]]()) { dict, month in
            dict[month] = emptyExpenses
        }
        
        return expenses.reduce(into: initialDict) { dict, expense in
            let monthNumber = calendar.component(.month, from: expense.date)
            dict[monthNumber]?.append(expense)
        }
    }
    
    private static func adjustedWeekNumber(date: Date) -> Int {
        let weekNumber = calendar.component(.weekOfYear, from: date)
        let monthNumber = calendar.component(.month, from: date)
        
        if (weekNumber == 1 && monthNumber == 12) {
            return 53
        }
        
        return weekNumber
    }
}

struct WeekExpenseRange {
    var weekStart: Date
    var weekEnd: Date
    var expenses: [Expense]
}
