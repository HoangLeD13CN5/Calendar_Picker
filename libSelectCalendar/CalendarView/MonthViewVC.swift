//
//  MonthViewVC.swift
//  libSelectCalendar
//
//  Created by Ominext on 9/14/18.
//  Copyright © 2018 mobile. All rights reserved.
//  View Month

import UIKit
protocol MonthViewDelegate: class {
    func tapInDay(_ day: DayView)
    func prepare(day: DayView)
    func didScrollToPage(_ page: MonthViewVC)
}

class MonthViewVC: UIViewController {
    let MAX_DAY_IN_MONTH = 42
    var date:Date = Date()
    var calendar = Calendar.current
    weak var delegate: MonthViewDelegate?
    private var listDayView:[DayView] = []
    
    init(date: Date) {
        super.init(nibName: nil, bundle: nil)
        self.date = date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
    }
    
    func initSubview() {
        //max is six week
        for _ in 0..<MAX_DAY_IN_MONTH {
            let view = DayView()
             view.delegate = self
            self.listDayView.append(view)
            self.view.addSubview(view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.delegate?.didScrollToPage(self)
    }
    
    func reloadData() {
        self.setupData()
    }
    
    private func setupData() {
        let beginDate = self.calendar.start(.month, ofDate: self.date)
        let firstWeekday = self.calendar.firstWeekday
        let weekdayOfBeginDate = self.calendar.weekday(ofDate: beginDate)
        let h = firstWeekday - weekdayOfBeginDate
        if let beginOfCalendar = self.calendar.date(byAdding: .day, value: h <= 0 ? h : h - 7, to: beginDate) {
            for i in 0..<listDayView.count {
                if let date = self.calendar.date(byAdding: .day, value: i, to: beginOfCalendar) {
                    listDayView[i].date = date
                    listDayView[i].reloadData()
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.reframe()
    }
    
    func dayViewOfDate(_ date: Date) -> DayView? {
        let beginDate = self.calendar.start(.month, ofDate: self.date)
        let firstWeekday = self.calendar.firstWeekday
        let weekdayOfBeginDate = self.calendar.weekday(ofDate: beginDate)
        if let beginOfCalendar = self.calendar.date(byAdding: .day, value: firstWeekday - weekdayOfBeginDate, to: beginDate) {
            if let h = self.calendar.dateComponents([.day], from: beginOfCalendar, to: date).day, h < MAX_DAY_IN_MONTH, h >= 0 {
                return listDayView[h]
            }
        }
        return nil
    }
    
    func reframe() {
        //day view
        for i in 0..<listDayView.count {
            let weekday = i % 7
            let weekMonth = i / 7
            let perX = self.view.bounds.size.width / 7.0
            let perY = CalendarViewConstant.DATE_VIEW_HEIGHT
            let x = CGFloat(weekday) * perX
            let y = CGFloat(weekMonth) * perY
            listDayView[i].frame = CGRect(x: x, y: y, width: perX, height: perY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension MonthViewVC: DayViewDelegate {
    
    func prepare(_ day: DayView) {
        self.delegate?.prepare(day: day)
    }
    
    func tapInDay(_ day: DayView) {
        self.delegate?.tapInDay(day)
    }
    
    func isFromOtherMonth(date: Date) -> Bool {
        return !self.calendar.date(date, isEqual: .month, with: self.date)
    }
}
