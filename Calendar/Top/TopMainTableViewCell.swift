//
//  TopMainTableViewCell.swift
//  Calendar
//
//  Created by ゲスト on 2020/08/24.
//  Copyright © 2020 Teacher. All rights reserved.
//

import UIKit

protocol TopMainTableViewCellDelegate: NSObjectProtocol{
}
extension TopMainTableViewCellDelegate {
}

// MARK: - Property
class TopMainTableViewCell: UITableViewCell {
    weak var delegate: TopMainTableViewCellDelegate? = nil
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
}

// MARK: - Life cycle
extension TopMainTableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - Protocol
extension TopMainTableViewCell {
}

// MARK: - method
extension TopMainTableViewCell {
    func updateCell(eventModel: [String:String]) {
        startLabel.text = eventModel["start_time"]
        endLabel.text = eventModel["end_time"]
        titleLabel.text = eventModel["title"]
        memoLabel.text = eventModel["memo"]
    }
}
