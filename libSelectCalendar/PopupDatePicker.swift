//
//  PopupDatePicker.swift
//  libSelectCalendar
//
//  Created by Ominext on 9/10/18.
//  Copyright © 2018 mobile. All rights reserved.
//

import UIKit
enum DatePickerType:Int{
    case day
    case month
    case year
}
class PopupDatePicker: UIViewController {
    // MARK: - UI Properties
    @IBOutlet weak var dimissView: UIView!
    @IBOutlet weak var heightForPickView: NSLayoutConstraint!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var btnSelectDate: UIBarButtonItem!
    @IBOutlet weak var lblTitle: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    // MARK: - Properties
    var calendar = Calendar.current
    var listYear:[Int] = []
    var listMonth:[Int] = []
    var listDay:[Int] = []
    var currentDay:Date = Date() {
        didSet {
            let year = calendar.component(.year, from: self.currentDay)
            let month = calendar.component(.month, from: self.currentDay)
            let day = calendar.component(.day, from: self.currentDay)
            if pickerView != nil {
                pickerView.selectRow(day - 1, inComponent: DatePickerType.day.rawValue, animated: true)
                pickerView.selectRow(self.indexAtMonth(month: month), inComponent: DatePickerType.month.rawValue, animated: true)
                let indexYear = self.indexAtYear(year: year)
                pickerView.selectRow( indexYear, inComponent: DatePickerType.year.rawValue, animated: true)
            }
        }
    }
    private var startDay:Date = Date()
    private var endDay:Date = Date()
    // MARK: - Block link Previous Screen
    var selectCurrentDate:((Date) -> Void)?
    
    // MARK: - LifeCycle UIController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.startDay = self.calendar.addNumberYearOfDayForDate(date: Date(), numberYear: -10)
        self.endDay = self.calendar.addNumberYearOfDayForDate(date: Date(), numberYear: 10)
        self.initListMonth()
        self.initListYear()
        self.currentDay = self.calendar.startOfDayForDate(date: Date())
        self.setUpGestureForDissmisView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.heightForPickView.constant = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.heightForPickView.constant = 180
            self.view.layoutIfNeeded()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Get/Set Properties
    func setUpGestureForDissmisView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.clickDimissView(_:)))
        self.dimissView.addGestureRecognizer(tap)
    }
    
    func setStartDayAndEndDay(startDay:Date,endDay:Date,currentDay:Date){
        if startDay < endDay {
            self.startDay = self.calendar.startOfDayForDate(date: startDay)
            self.endDay = self.calendar.startOfDayForDate(date: endDay)
            self.initListMonth()
            self.initListYear()
            if startDay <= currentDay && currentDay <= endDay {
                 self.currentDay = self.calendar.startOfDayForDate(date: currentDay)
            }else {
                self.currentDay = self.startDay
            }
        }
    }
    
    // MARK: - Action UI
    
    @IBAction func clickCancel(_ sender: Any) {
        UIView.animate(withDuration: 0.25) {
            self.heightForPickView.constant = -180
            self.view.layoutIfNeeded()
        }
        self.perform(#selector(dissmissPopup), with: nil, afterDelay: 0.25)
    }
    
    @IBAction func clickOk(_ sender: Any) {
        UIView.animate(withDuration: 0.25) {
            self.heightForPickView.constant = -180
            self.view.layoutIfNeeded()
        }
        self.selectCurrentDate?(self.currentDay)
        self.perform(#selector(dissmissPopup), with: nil, afterDelay: 0.25)
    }
    
    @objc func clickDimissView(_ sender: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.25) {
            self.heightForPickView.constant = -180
            self.view.layoutIfNeeded()
        }
        self.perform(#selector(dissmissPopup), with: nil, afterDelay: 0.25)
    }
    
    // MARK: - Other Method
    @objc func dissmissPopup(){
        self.dismiss(animated: false, completion: nil)
    }
    
}
// MARK: - Picker DataSource
extension PopupDatePicker:UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        switch component {
        case DatePickerType.day.rawValue:
            return self.getNumberDayOfMonth(date: self.currentDay)
        case DatePickerType.month.rawValue:
            return self.listMonth.count
        default:
            return self.listYear.count
        }
    }
}
// MARK: - Picker Delegate
extension PopupDatePicker:UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat{
        let width = UIScreen.main.bounds.size.width
        return width/3
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 32
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        switch component {
        case DatePickerType.day.rawValue:
            let titleData = "\(row+1)"
            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.black])
            pickerLabel.attributedText = myTitle
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
        case DatePickerType.month.rawValue:
            let titleData = "\(self.listMonth[row])"
            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.black])
            pickerLabel.attributedText = myTitle
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
        default:
            let titleData = "\(listYear[row])"
            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.black])
            pickerLabel.attributedText = myTitle
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let year: Int = self.listYear[self.pickerView.selectedRow(inComponent: DatePickerType.year.rawValue)]
        let month: Int = self.listMonth[self.pickerView.selectedRow(inComponent: DatePickerType.month.rawValue)]
        let day: Int = self.pickerView.selectedRow(inComponent: DatePickerType.day.rawValue) + 1
        self.currentDay = self.calendar.convertToDate(day: day, month: month, year: year)
        if component == DatePickerType.month.rawValue {
            pickerView.reloadComponent(DatePickerType.day.rawValue)
        }
    }
    
    
}
// MARK: - Private Method
extension PopupDatePicker {
    //MARK: - Set up for propeties
    private func initListMonth() {
        for i in 0...11 {
            listMonth.append(i+1)
        }
    }
    
    private func initListYear() {
        self.listYear.removeAll()
        let startListYear = self.calendar.component(.year, from: self.startDay)
        let endListYear = self.calendar.component(.year, from: self.endDay)
        for year in startListYear...endListYear {
            self.listYear.append(year)
        }
    }
    
    private func getNumberDayOfMonth(date:Date) -> Int{
        let startMonth = self.calendar.startMonthForDate(date: date)
        let endMonth = self.calendar.previousOfDayForDate(date: self.calendar.nextMonthForDate(date: date))
        return calendar.component(.day, from: endMonth) - calendar.component(.day, from: startMonth) + 1
    }
    
    private func indexAtYear(year:Int) -> Int {
        return self.listYear.index(of: year) ?? -1
    }
    
    private func indexAtMonth(month:Int) -> Int {
        return self.listMonth.index(of: month) ?? -1
    }
    
    
}

