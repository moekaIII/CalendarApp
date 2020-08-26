//
//  Global.swift
//
//  Created by ゲスト on 2020/08/24.
//  Copyright © 2020 Teacher. All rights reserved.
//
import UIKit
//import CalculateCalendarLogic

//for ViewController
extension UIViewController {
    public func loadNib() {
        let moduleName = NSStringFromClass(type(of: self) as AnyClass)
        let startIndex = moduleName.firstIndex(of: ".")!
        let indexAfterModuleName = moduleName.index(after: startIndex)
        let classname = moduleName[indexAfterModuleName...]
        
        let name = classname
        let nib: UINib = UINib.init(nibName: String(name), bundle: nil)
        let _: [Any]? = nib.instantiate(withOwner: self, options: nil)
    }
    //キーボードとテキストフィールド以外をタップでキーボードを隠す
    public func hideKeybord() {
        let hideTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKyeoboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
    }
    @objc func hideKyeoboardTap(recognizer : UITapGestureRecognizer){
        self.view.endEditing(true)
    }
}

//for View
extension UIView {
    public func loadNib() {
        var views: [Any]?
        
        let className = String(describing: type(of: self))
        let nib: UINib = UINib.init(nibName: className, bundle: nil)
        let result: [Any]? = nib.instantiate(withOwner: self, options: nil)
        views = result
        
        if let contentView = views?.first as? UIView {
            contentView.frame = bounds
            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            addSubview(contentView)
        }
    }
}

//TableViewCell
public func loadTableViewCellFromXib(tableView: UITableView, cellName: String) {
    let nib = UINib.init(nibName: cellName, bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: cellName)
}

//Date
//public func getDay(_ date:Date) -> (String){
//    let tmpCalendar = Calendar(identifier: .gregorian)
//    let year = tmpCalendar.component(.year, from: date)
//    let month = tmpCalendar.component(.month, from: date)
//    let day = tmpCalendar.component(.day, from: date)
//    return ("\(year).\(month).\(day)")
//}
// 祝日判定を行い結果を返すメソッド(True:祝日)
//public func judgeHoliday(_ date : Date) -> Bool {
//    //祝日判定用のカレンダークラスのインスタンス
//    let tmpCalendar = Calendar(identifier: .gregorian)
//
//    // 祝日判定を行う日にちの年、月、日を取得
//    let year = tmpCalendar.component(.year, from: date)
//    let month = tmpCalendar.component(.month, from: date)
//    let day = tmpCalendar.component(.day, from: date)
//
//    // CalculateCalendarLogic()：祝日判定のインスタンスの生成
//    let holiday = CalculateCalendarLogic()
//
//    return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
//}
//曜日判定(日曜日:1 〜 土曜日:7)
public func getWeekIdx(_ date: Date) -> Int{
    let tmpCalendar = Calendar(identifier: .gregorian)
    return tmpCalendar.component(.weekday, from: date)
}

public func dateFromString(string: String, format: String) -> Date {
    let formatter: DateFormatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.dateFormat = format
    return formatter.date(from: string) ?? Date()
}

public func stringFromDate(date: Date, format: String) -> String {
    let formatter: DateFormatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.dateFormat = format
    return formatter.string(from: date)
}

public func judgeEmail(text: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z.%+-]+@[A-za-z0-9.-]+\\.[A-za-z]{2,6}"
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: text)
}


public func alert(vc: UIViewController, title: String, message: String, isCancel: Bool) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default) { (action) in
        vc.dismiss(animated: true, completion: nil)
    }
    alert.addAction(ok)
    if isCancel {
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (acrion) in
            vc.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
    }
    vc.present(alert, animated: true, completion: nil)
}
