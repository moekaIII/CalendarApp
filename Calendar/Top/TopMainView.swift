//
//  TopMainView.swift
//  Calendar
//
//  Created by ゲスト on 2020/08/24.
//  Copyright © 2020 Teacher. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic

protocol TopMainViewDelegate: NSObjectProtocol{
    func touchedAddEventButton(date: NSDate)
    func deleteModel(selectedDate: String, indexPath: IndexPath)
}
extension TopMainViewDelegate {
}

// MARK: - Property
class TopMainView: UIView {
    weak var delegate: TopMainViewDelegate? = nil
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var selectedDayLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addEventButton: UIButton!
    @IBAction func touchedAddEventButton(_ sender: UIButton) {
        delegate?.touchedAddEventButton(date: selectedDate)
    }
    
    var selectedDate: NSDate = NSDate()
    var eventModels: [[String:String]] = []
    var filterdModels: [[String:String]] = []
}

// MARK: - Life cycle
extension TopMainView {
    override func awakeFromNib() {
        super.awakeFromNib()
        loadNib()
        setLayout()
        setDelegate()
        loadTableViewCellFromXib(tableView: tableView, cellName: "TopMainTableViewCell")
    }
}
    
// MARK: - Protocol
extension TopMainView: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date as NSDate
        filterModel()
        selectedDayLabel.text = stringFromDate(date: date, format: "yyyy.MM.dd")
        tableView.reloadData()
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if judgeHoliday(date) {
            return UIColor.red
        }
        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return UIColor.red
        }
        else if weekday == 7 {  //土曜日
            return UIColor.blue
        }

        return nil
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let date = stringFromDate(date: date, format: "yyyy.MM.dd")
        var hasEvent: Bool = false
        for eventModel in eventModels {
            if eventModel["date"] == date {
                hasEvent = true
            }
        }
        if hasEvent {
            return 1
        } else {
            return 0
        }
    }
}

extension TopMainView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterdModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopMainTableViewCell", for: indexPath) as? TopMainTableViewCell else {return UITableViewCell()}
        cell.updateCell(eventModel: filterdModels[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            filterdModels.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            delegate?.deleteModel(selectedDate: stringFromDate(date: selectedDate as Date, format: "yyyy.MM.dd"),
                                  indexPath: indexPath)
        }
    }
}

// MARK: - method
extension TopMainView {
    func setDelegate() {
        calendarView.dataSource = self
        calendarView.delegate = self
        tableView.dataSource = self
    }
    
    func setLayout() {
        calendarView.layer.cornerRadius = 10
        calendarView.layer.shadowOpacity = 0.2
        calendarView.layer.shadowOffset = CGSize(width: 0, height: 0)
        calendarView.layer.shadowRadius = 3.0
        
        eventView.layer.cornerRadius = 10
        eventView.layer.shadowOpacity = 0.2
        eventView.layer.shadowOffset = CGSize(width: 0, height: 0)
        eventView.layer.shadowRadius = 3.0
        
        tableView.layer.cornerRadius = 10
    }
    func getModel(eventModels: [[String:String]]) {
        self.eventModels = eventModels
        calendarView.reloadData()
        filterModel()
        tableView.reloadData()
    }
    func filterModel() {
        var filterdEvents: [[String:String]] = []
        for eventModel in eventModels {
            if eventModel["date"] == stringFromDate(date: selectedDate as Date, format: "yyyy.MM.dd") {
                filterdEvents.append(eventModel)
            }
        }
        filterdModels = filterdEvents
    }
}
