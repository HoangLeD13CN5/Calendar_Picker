//
//  Calendar+Extention.swift
//  libSelectCalendar
//
//  Created by Ominext on 9/10/18.
//  Copyright © 2018 mobile. All rights reserved.
//

import Foundation

extension Calendar {
     // MARK: - Utils Day
    func startOfDayForDate(date:Date) -> Date {
        let calendarComponents : Set<Calendar.Component> = [ .year, .month, .day]
        return self.date(from: self.dateComponents(calendarComponents, from: date))!
    }
    
    func nextOfDayForDate(date:Date) -> Date {
        return self.startOfDayForDate(date: self.date(byAdding: .day, value: 1, to: date)!)
    }
    
    func previousOfDayForDate(date:Date) -> Date {
        return self.startOfDayForDate(date: self.date(byAdding: .day, value: -1, to: date)!)
    }
    
    // MARK: - Utils Month
    func startMonthForDate(date:Date) -> Date {
        let components = self.dateComponents([ .year, .month ], from: date)
        return self.date(from: components)!
    }
    
    func nextMonthForDate(date:Date) -> Date {
        return self.startMonthForDate(date: self.date(byAdding: .month, value: 1, to: date)!)
    }
    
    func previousMonthForDate(date:Date) -> Date {
        return self.startMonthForDate(date: self.date(byAdding: .month, value: -1, to: date)!)
    }
    
    // MARK: - Utils Year
    func startYearForDate(date:Date) -> Date {
        let components = self.dateComponents([ .year ], from: date)
        return self.date(from: components)!
    }
    
    func addNumberYearOfDayForDate(date:Date,numberYear:Int) -> Date{
        return self.startYearForDate(date: self.date(byAdding: .year, value: numberYear, to: date)!)
    }
    // MARK: - Convert Date
    func convertToDate(day:Int,month:Int,year:Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return self.date(from: dateComponents) ?? Date()
    }
    
}
