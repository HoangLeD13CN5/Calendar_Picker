//
//  DayView.swift
//  libSelectCalendar
//
//  Created by Ominext on 9/14/18.
//  Copyright © 2018 mobile. All rights reserved.
//

import UIKit
protocol DayViewDelegate {
    func isFromOtherMonth(date: Date) -> Bool
    func tapInDay(_ day: DayView)
    func prepare(_ day: DayView)
}

class DayView: UIView {
    var date:Date = Date()
    private var calendar = Calendar.current
    var delegate:DayViewDelegate?
    private var labelTitle:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private var connerView:UIView = {
        let conner = UIView()
        conner.backgroundColor = UIColor.orange
        conner.layer.masksToBounds = true
        return conner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        initSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hiddenConnerView(_ isShow: Bool){
        self.connerView.isHidden = isShow
    }
    
    func initSubView() {
        // add subview
        self.addSubview(connerView)
        self.hiddenConnerView(true)
        self.addSubview(labelTitle)
        // add gesture
        let gesture = UIGestureRecognizer(target: self, action: #selector(handDayTap(sender:)))
        self.addGestureRecognizer(gesture)
    }
    
    @objc func handDayTap(sender:UIGestureRecognizer){
        // click in UIView
        delegate?.tapInDay(self)
    }
    
    // set Data For View
    func reloadData(){
        // show other color in weekend
        switch calendar.weekday(ofDate: self.date) {
        case EKWeek.sunday.rawValue:
            self.labelTitle.textColor = UIColor.red
            break
        case EKWeek.saturday.rawValue:
            self.labelTitle.textColor = UIColor.blue
            break
        default:
            self.labelTitle.textColor = UIColor.black
            break
        }
        self.labelTitle.text = "\(calendar.day(ofDate: self.date))"
        delegate?.prepare(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.reframe()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.reframe()
    }
    
    func isFromOtherMonth() -> Bool {
        guard let boolen = self.delegate?.isFromOtherMonth(date: self.date) else {return true}
        return boolen
    }
    
    private func reframe() {
        labelTitle.sizeToFit()
        labelTitle.frame = self.bounds
        let selfSize = self.bounds.size
        let width = min(self.bounds.size.width, self.bounds.size.height)
        connerView.frame = CGRect(x: selfSize.width / 2.0 - width / 2.0, y: selfSize.height / 2.0 - width / 2.0, width: width, height: width)
        connerView.layer.cornerRadius = width / 2.0
    }
    
    
}
