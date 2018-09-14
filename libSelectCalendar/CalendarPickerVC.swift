//
//  CalendarPickerVC.swift
//  libSelectCalendar
//
//  Created by Ominext on 9/14/18.
//  Copyright © 2018 mobile. All rights reserved.
//

import UIKit
protocol CalendarPickerVCDelegate {
    func calendarView(_ calendarView: CalendarPickerView, didSelectDate date: Date)
}
class CalendarPickerVC: UIViewController {
    
    @IBOutlet weak var btnPrevios: UIBarButtonItem!
    @IBOutlet weak var calendarPicker: CalendarPickerView!
    @IBOutlet weak var txtTitle: UIBarButtonItem!
    
    @IBOutlet weak var btnNext: UIBarButtonItem!
    
    var currentDate:Date = Date()
    var delegate:CalendarPickerVCDelegate?
    var calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.calendarPicker.date = currentDate
        self.calendarPicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    @IBAction func clickBtnPrevious(_ sender: Any) {
        let date = self.calendarPicker.date
        if let newDate = calendar.date(byAdding: .month, value: -1, to: date){
             self.calendarPicker.scrollToDate(newDate)
        }
    }
    
    @IBAction func clickBtnNext(_ sender: Any) {
        let date = self.calendarPicker.date
        if let newDate = calendar.date(byAdding: .month, value: 1, to: date){
            self.calendarPicker.scrollToDate(newDate)
        }
    }
    
    func update(_ date: Date?) {
        guard let date = date else {return}
        self.currentDate = date
        self.txtTitle.title = "Tháng \(self.calendar.component(.day, from: date))"
    }
}

extension CalendarPickerVC:CalendarPickerDelegate {
    func calendarViewDidScroll(_ calendar: CalendarPickerView) {
        btnNext.isEnabled = false
        btnPrevios.isEnabled = false
    }
    
    func calendarViewDidEndScroll(_ calendar: CalendarPickerView) {
        btnNext.isEnabled = true
        btnPrevios.isEnabled = true
    }
    
    func calendarView(_ calendar: CalendarPickerView, didSelectedAt day: DayView){
        self.delegate?.calendarView(calendar, didSelectDate: day.date)
    }
    
    func calendarView(_ calendar: CalendarPickerView, didScrollTo date: Date) {
        self.update(date)
    }
}
