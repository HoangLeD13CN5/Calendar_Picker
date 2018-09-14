//
//  Calendar+Extention.swift
//  libSelectCalendar
//
//  Created by Ominext on 9/10/18.
//  Copyright © 2018 mobile. All rights reserved.
//

import Foundation

enum EKWeek:Int {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}
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
    // MARK: - Utils Date
    func convertToDate(day:Int,month:Int,year:Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return self.date(from: dateComponents) ?? Date()
    }
    
    func weekday(ofDate: Date) -> Int {
        return self.component(.weekday, from: ofDate)
    }
    
    func second(ofDate: Date) -> Int {
        return self.component(.second, from: ofDate)
    }
    
    func minute(ofDate: Date) -> Int {
        return self.component(.minute, from: ofDate)
    }
    
    func day(ofDate: Date) -> Int {
        return self.component(.day, from: ofDate)
    }
    
    func month(ofDate: Date) -> Int {
        return self.component(.month, from: ofDate)
    }
    
    func year(ofDate: Date) -> Int {
        return self.component(.year, from: ofDate)
    }
    
    func start(_ component: Calendar.Component, ofDate: Date) -> Date {
        switch component {
        case .second:
            let com = self.dateComponents([.year, .month, .day, .hour, .minute, .second], from: ofDate)
            if let newDate = self.date(from: com) { return newDate }
            break
        case .minute:
            let com = self.dateComponents([.year, .month, .day, .hour, .minute], from: ofDate)
            if let newDate = self.date(from: com) { return newDate }
            break
        case .hour:
            let com = self.dateComponents([.year, .month, .day, .hour], from: ofDate)
            if let newDate = self.date(from: com) { return newDate }
            break
        case .day:
            let com = self.dateComponents([.year, .month, .day], from: ofDate)
            if let newDate = self.date(from: com) { return newDate }
            break
            
        case .month:
            let com = self.dateComponents([.year, .month], from: ofDate)
            if let newDate = self.date(from: com) { return newDate }
            break
            
        case .year:
            let com = self.dateComponents([.year], from: ofDate)
            if let newDate = self.date(from: com) { return newDate }
            break
            
        default:
            return ofDate
        }
        return ofDate
    }
    
    func end(_ component: Calendar.Component, ofDate: Date) -> Date {
        switch component {
        case .month:
            guard let nextMonth = self.date(byAdding: .month, value: 1, to: ofDate) else {return ofDate}
            let startNextMonth = self.start(.month, ofDate: nextMonth)
            return self.date(byAdding: .second, value: -1, to: startNextMonth) ?? ofDate
        default:
            return ofDate
        }
    }
    
    func date(_ date: Date, isEqual component: Calendar.Component, with otherDate: Date) -> Bool {
        let com1 = self.dateComponents([.year, .day, .month, .second, .minute, .second], from: date)
        let com2 = self.dateComponents([.year, .day, .month, .second, .minute, .second], from: otherDate)
        switch component {
        case .second:
            return com1.year == com2.year && com1.month == com2.month && com1.day == com2.day && com1.minute == com2.minute && com1.second == com2.second
        case .minute:
            return com1.year == com2.year && com1.month == com2.month && com1.day == com2.day && com1.minute == com2.minute
        case .day:
            return com1.year == com2.year && com1.month == com2.month && com1.day == com2.day
        case .month:
            return com1.year == com2.year && com1.month == com2.month
        case .year:
            return com1.year == com2.year
        default:
            return false
        }
    }
    
}
