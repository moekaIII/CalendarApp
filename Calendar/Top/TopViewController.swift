//
//  TopViewController.swift
//  Calendar
//
//  Created by ゲスト on 2020/08/24.
//  Copyright © 2020 Teacher. All rights reserved.
//

import UIKit
import RealmSwift

// MARK: - Property
class TopViewController: UIViewController {
    @IBOutlet weak var mainView: TopMainView!
    
    //data
    let realm = try! Realm()
    var eventModels: [[String:String]] = []
}

// MARK: - Life cycle
extension TopViewController {
    override func loadView() {
        super.loadView()
        loadNib()
        setDelegate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getModel()
    }
}

// MARK: - Protocol
extension TopViewController: TopMainViewDelegate {
    func deleteModel(selectedDate: String, indexPath: IndexPath) {
        let results = realm.objects(EventModel.self).filter("date == '\(selectedDate)'")
        do {
            try realm.write {
                realm.delete(results[indexPath.row])
                getModel()
            }
        } catch {
            print("delete data error.")
        }
    }
    
    func touchedAddEventButton(date: NSDate) {
        let inputViewController = InputViewController()
        inputViewController.date = date
        inputViewController.modalPresentationStyle = .fullScreen
        present(inputViewController, animated: true, completion: nil)
    }
}

// MARK: - method
extension TopViewController {
    func setDelegate() {
        mainView.delegate = self
    }
    func getModel() {
        let results = realm.objects(EventModel.self)
        var eventModels: [[String:String]] = []
        for result in results {
            eventModels.append(["title": result.title,
                                "memo": result.memo,
                                "date": result.date,
                                "start_time": result.start_time,
                                "end_time": result.end_time])
        }
        mainView.getModel(eventModels: eventModels)
    }
}
