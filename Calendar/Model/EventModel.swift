//
//  EventModel.swift
//  Calendar
//
//  Created by ゲスト on 2020/08/24.
//  Copyright © 2020 Teacher. All rights reserved.
//

import RealmSwift

class EventModel: Object {
    @objc dynamic var title = ""
    @objc dynamic var memo = ""
    @objc dynamic var date = "" //yyyy.MM.dd
    @objc dynamic var start_time = "" //00:00
    @objc dynamic var end_time = "" //00:00
}
