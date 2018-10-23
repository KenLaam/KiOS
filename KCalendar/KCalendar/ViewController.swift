//
//  ViewController.swift
//  KCalendar
//
//  Created by Ken Lâm on 10/23/18.
//  Copyright © 2018 KPU. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var lblMonthYear: UILabel!
    @IBOutlet weak var btnPrev: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    let CELL_ID = "DateCell"
    
    let START_DATE = "2018 09 01"
    let END_DATE = "2019 09 30"
    
    let FORMAT_FULL = "yyyy MM dd"
    let FORMAT_MONTH_YEAR = "MMM yyyy"
    
    let AVAILABLE_DATES_STRING = ["2018 09 27",
                           "2018 09 02",
                           "2019 09 02",
                           "2018 10 26",
                           "2018 10 23",
                           "2018 10 23",
                           "2019 09 02",
                           "2019 09 27"]
    
    var AVAILABLE_DATES: [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCalendarView()
        btnNext.addTarget(self, action: #selector(onTapNextMonth), for: .touchUpInside)
        btnPrev.addTarget(self, action: #selector(onTapPrevMonth), for: .touchUpInside)
        AVAILABLE_DATES = AVAILABLE_DATES_STRING.map({ $0.date(format: FORMAT_FULL) }).sorted(by: { $0 < $1 })
        AVAILABLE_DATES.removeDuplicates()

    }

    func configCalendarView() {
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.register(UINib(nibName: CELL_ID, bundle: nil), forCellWithReuseIdentifier: CELL_ID)
        calendarView.visibleDates {
            self.updateMonthYearLabel(from: $0)
        }
    }
    
    func updateMonthYearLabel(from visibleDates: DateSegmentInfo) {
        lblMonthYear.text = visibleDates.monthDates.first!.date.string(format: self.FORMAT_MONTH_YEAR)
    }
    
    @objc func onTapNextMonth() {
        calendarView.scrollToSegment(SegmentDestination.next)
        
    }
    
    @objc func onTapPrevMonth() {
        calendarView.scrollToSegment(SegmentDestination.previous)
    }

}

extension ViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        handleCellUI(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: CELL_ID, for: indexPath) as! DateCell
        cell.lblDate.text = cellState.text
        handleCellUI(view: cell, cellState: cellState)
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        return ConfigurationParameters(startDate: START_DATE.date(format: FORMAT_FULL), endDate: END_DATE.date(format: FORMAT_FULL))
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        updateMonthYearLabel(from: visibleDates)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        updateMonthYearLabel(from: visibleDates)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellUI(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellUI(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        return AVAILABLE_DATES.contains(date)
    }

    
    func handleCellUI(view: JTAppleCell?, cellState: CellState) {
        guard let cell  = view as? DateCell else { return }
        var textColor: UIColor
        if AVAILABLE_DATES.contains(cellState.date) {
            if cellState.isSelected {
                textColor = .white
            } else {
                textColor = .black
            }
        } else {
            textColor = .lightGray
        }
        cell.lblDate.textColor = textColor
        cell.lblDate.isHidden = cellState.dateBelongsTo != .thisMonth
        cell.viewBackground.isHidden = !(cellState.isSelected && cellState.dateBelongsTo == .thisMonth)
    }
}

