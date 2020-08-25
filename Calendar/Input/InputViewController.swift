//
//  InputViewController.swift
//  Calendar
//
//  Created by ゲスト on 2020/08/24.
//  Copyright © 2020 Teacher. All rights reserved.
//

import UIKit
import RealmSwift

// MARK: - Property
class InputViewController: UIViewController {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBOutlet weak var startTextField: UITextField!
    
    @IBOutlet weak var endTextField: UITextField!
    @IBAction func touchedCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func touchedDoneButton(_ sender: UIButton) {
        createEvent {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    var date: NSDate = NSDate()
    var pickerView = UIPickerView()
    var timeList: [String] = [String]()
    var selectedTextField: UITextField = UITextField()
}

// MARK: - Life cycle
extension InputViewController {
    override func loadView() {
        super.loadView()
        loadNib()
        setLayout()
        hideKeybord()
        setDelegate()
        setTimeList()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Protocol
extension InputViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedTextField == startTextField {
            startTextField.text = timeList[row]
        } else if selectedTextField == endTextField {
            endTextField.text = timeList[row]
        } else {
            return
        }
    }
}

extension InputViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        selectedTextField = textField
        textField.inputView = pickerView
        return true
    }
}

// MARK: - method
extension InputViewController {
    func setDelegate() {
        pickerView.delegate = self
        pickerView.dataSource = self
        startTextField.delegate = self
        endTextField.delegate = self
    }
    func setLayout() {
        memoTextView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        memoTextView.layer.borderWidth = 0.5
        memoTextView.layer.cornerRadius = 10
        
        dayLabel.text = stringFromDate(date: date as Date, format: "yyyy.MM.dd")
    }
    func setTimeList() {
        for i in 1...24 {
            timeList.append("\(i):00")
            timeList.append("\(i):30")
        }
    }
    func createEvent(success: @escaping () -> Void) {
        do {
            let realm = try Realm()
            let eventModel = EventModel()
            eventModel.title = titleTextField.text ?? ""
            eventModel.memo = memoTextView.text
            eventModel.date = stringFromDate(date: date as Date, format: "yyyy.MM.dd")
            eventModel.start_time = startTextField.text ?? ""
            eventModel.end_time = endTextField.text ?? ""
            
            try realm.write {
                realm.add(eventModel)
                success()
            }
        } catch {
            print("create todo error.")
        }
    }
    
}

