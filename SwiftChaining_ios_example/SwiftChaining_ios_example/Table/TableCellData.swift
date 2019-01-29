//
//  TableCellData.swift
//

import Foundation
import Chaining

protocol CellData {
    var canEdit: Bool { get }
    var canMove: Bool { get }
    var canTap: Bool { get }
    var cellIdentifier: String { get }
}

protocol CellDataSettable {
    func set(cellData: CellData)
}

// MARK: - NormalCellData

struct NormalCellData: CellData {
    let canEdit = true
    let canMove = true
    let canTap = true
    let cellIdentifier = "NormalCell"
    
    let text: ValueHolder<String>
    let detailText: ValueHolder<String>
    
    init(text: String, detailText: String) {
        self.text = ValueHolder(text)
        self.detailText = ValueHolder(detailText)
    }
}

// MARK: - CustomCellData

struct CustomCellData: CellData {
    let canEdit = false
    let canMove = false
    let canTap = false
    let cellIdentifier = "CustomCell"
    
    var number: ValueHolder<Int>
    
    init(number: Int) {
        self.number = ValueHolder(number)
    }
}

// MARK: - EditCellData

struct EditCellData: CellData {
    let canEdit = false
    let canMove = false
    let canTap = false
    let cellIdentifier = "EditCell"
    
    let isEditing = ValueHolder<Bool>(false)
}
