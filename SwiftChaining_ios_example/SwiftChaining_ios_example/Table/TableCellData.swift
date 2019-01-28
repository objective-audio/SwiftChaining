//
//  TableCellData.swift
//

import Foundation
import Chaining

enum CellIdentifier: String {
    case normal = "NormalCell"
    case custom = "CustomCell"
    case edit = "EditCell"
}

final class CellData {
    let canEdit: Bool
    let canMove: Bool
    let canTap: Bool
    let cellIdentifier: CellIdentifier
    let additional: AdditionalCellData
    
    enum Event {
        case cellTapped
        case accessoryTapped
    }
    
    init(canEdit: Bool, canMove: Bool, canTap: Bool, cellIdentifier: CellIdentifier, additional: AdditionalCellData) {
        self.canEdit = canEdit
        self.canMove = canMove
        self.canTap = canTap
        self.cellIdentifier = cellIdentifier
        self.additional = additional
    }
}

protocol AdditionalCellData {
}

protocol CellDataSettable {
    func set(cellData: CellData)
}

// MARK: - NormalCellData

struct NormalCellData: AdditionalCellData {
    let text: ValueHolder<String>
    let detailText: ValueHolder<String>
    
    static func cellData(text: String, detailText: String) -> CellData {
        let normalCellData = NormalCellData(text: ValueHolder(text), detailText: ValueHolder(detailText))
        return CellData(canEdit: true, canMove: true, canTap: true, cellIdentifier: .normal, additional: normalCellData)
    }
}

// MARK: - CustomCellData

struct CustomCellData: AdditionalCellData {
    var number: ValueHolder<Int>
    
    static func cellData(number: Int) -> CellData {
        let customCellData = CustomCellData(number: ValueHolder(number))
        return CellData(canEdit: false, canMove: false, canTap: false, cellIdentifier: .custom, additional: customCellData)
    }
}

// MARK: - EditCellData

struct EditCellData: AdditionalCellData {
    let isEditing = ValueHolder<Bool>(false)
    var pool = ObserverPool()
    
    static func cellData() -> CellData {
        let editCellData = EditCellData()
        return CellData(canEdit: false, canMove: false, canTap: false, cellIdentifier: .edit, additional: editCellData)
    }
}
