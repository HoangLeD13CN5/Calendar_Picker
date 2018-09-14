//
//  CalendarPickerView.swift
//  libSelectCalendar
//
//  Created by Ominext on 9/14/18.
//  Copyright © 2018 mobile. All rights reserved.
//

import UIKit
@objc protocol CalendarPickerDelegate {
    @objc optional func calendarView(_ calendar: CalendarPickerView, didSelectedAt day: DayView)
    @objc optional func calendarView(_ calendar: CalendarPickerView, prepare day: DayView)
    @objc optional func calendarView(_ calendar: CalendarPickerView, didScrollTo date: Date)
    @objc optional func calendarView(_ calendar: CalendarPickerView, canBackTo date: Date) -> Bool
    @objc func calendarViewDidScroll(_ calendar: CalendarPickerView)
    @objc func calendarViewDidEndScroll(_ calendar: CalendarPickerView)
}
class CalendarPickerView: UIView {
    //public
    var date = Date()
    var calendar = Calendar.current
    weak var delegate: CalendarPickerDelegate?
    
    private var listPage: [MonthViewVC] = []
    
    //private
    fileprivate var pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    init() {
        super.init(frame: CGRect.zero)
        self.initPageVC()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initPageVC()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    init(date: Date) {
        super.init(frame: CGRect.zero)
        self.date = date
        self.initPageVC()
    }
    
    func setCurrentDate(date: Date){
        self.date = date
        self.initPageVC()
    }

    func reloadDataOfDate(_ date: Date) {
        for item in listPage {
            if let day = item.dayViewOfDate(date) {
                day.reloadData()
                break
            }
        }
    }
    
    func reloadData() {
        for item in listPage {
            item.calendar = self.calendar
            item.reloadData()
        }
        self.delegate?.calendarView?(self, didScrollTo: self.date)
    }
    
    public func scrollToDate(_ date: Date) {
        if let current = self.pageVC.viewControllers?.last as? MonthViewVC, let next = self.getNextVC(current: current), let prev = self.getPrevVC(current: current), !self.calendar.date(date, isEqual: .month, with: self.date) {
            
            var direction = UIPageViewControllerNavigationDirection.forward
            if self.date.compare(date) == .orderedAscending {
                self.date = date
                self.listPage = [current, next, prev]
            } else if self.date.compare(date) == .orderedDescending {
                self.date = date
                self.listPage = [next, prev, current]
                direction = .reverse
            }
            
            listPage[1].date = self.date
            self.pageVC.setViewControllers([listPage[1]], direction: direction, animated: true, completion: nil)
            listPage[2].date = self.calendar.date(byAdding: .month, value: 1, to: self.date)!
            listPage[0].date = self.calendar.date(byAdding: .month, value: -1, to: self.date)!
        }
    }
    
    private func initPageVC() {
        self.addSubview(pageVC.view)
        pageVC.delegate = self
        pageVC.dataSource = self
        
        let first = MonthViewVC(date: self.calendar.date(byAdding: .month, value: -1, to: self.date)!)
        first.view.backgroundColor = .white
        first.delegate = self
        let second = MonthViewVC(date: self.date)
        second.view.backgroundColor = .white
        second.delegate = self
        let third = MonthViewVC(date: self.calendar.date(byAdding: .month, value: 1, to: self.date)!)
        third.view.backgroundColor = .white
        third.delegate = self
        listPage = [first, second, third]
        self.pageVC.setViewControllers([self.listPage[1]], direction: .forward, animated: true, completion: nil)
        
        for view in self.pageVC.view.subviews {
            if view is UIScrollView {
                (view as! UIScrollView).delegate = self
                break
            }
        }
    }
    
    private func getNextVC(current: MonthViewVC) -> MonthViewVC? {
        if listPage.contains(current), let index = listPage.index(of: current) {
            var new: MonthViewVC?
            if index == listPage.count - 1 {
                new = listPage.first
            } else if index < listPage.count {
                new = listPage[index + 1]
            }
            return new
        }
        return nil
    }
    
    private func getPrevVC(current: MonthViewVC) -> MonthViewVC? {
        if let current = self.pageVC.viewControllers?.last as? MonthViewVC, listPage.contains(current), let index = listPage.index(of: current) {
            var new: MonthViewVC?
            if index == 0 {
                new = listPage.last
            } else if index < listPage.count {
                new = listPage[index - 1]
            }
            return new
        }
        return nil
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        pageVC.view.frame = self.bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pageVC.view.frame = self.bounds
    }
}

extension CalendarPickerView: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let current = self.pageVC.viewControllers?.last as? MonthViewVC, let new = getPrevVC(current: current) {
            new.date = calendar.date(byAdding: .month, value: -1, to: self.date)!
            if self.delegate?.calendarView?(self, canBackTo: new.date) ?? true {
                return new
            }
        }
        return nil
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let current = self.pageVC.viewControllers?.last as? MonthViewVC, let new = getNextVC(current: current) {
            new.date = calendar.date(byAdding: .month, value: 1, to: self.date)!
            return new
        }
        return nil
    }
}

extension CalendarPickerView: UIPageViewControllerDelegate, UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == scrollView.bounds.size.width {
            self.delegate?.calendarViewDidEndScroll(self)
        } else {
            self.delegate?.calendarViewDidScroll(self)
        }
    }
}

extension CalendarPickerView: MonthViewDelegate {
    func prepare(day: DayView) {
        self.delegate?.calendarView?(self, prepare: day)
    }
    
    func tapInDay(_ day: DayView) {
        self.delegate?.calendarView?(self, didSelectedAt: day)
    }
    
    func didScrollToPage(_ page: MonthViewVC) {
        self.date = page.date
        self.delegate?.calendarView?(self, didScrollTo: self.date)
    }
}

