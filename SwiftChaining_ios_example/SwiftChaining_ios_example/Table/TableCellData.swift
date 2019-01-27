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

class CellData {
    let canEdit: Bool
    let canMove: Bool
    let canTap: Bool
    let cellIdentifier: CellIdentifier
    let additional: AdditionalCellData
    
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
    let text: Holder<String>
    let detailText: Holder<String>
    
    static func cellData(text: String, detailText: String) -> CellData {
        let normalCellData = NormalCellData(text: Holder(text), detailText: Holder(detailText))
        return CellData(canEdit: true, canMove: true, canTap: true, cellIdentifier: .normal, additional: normalCellData)
    }
}

// MARK: - CustomCellData

struct CustomCellData: AdditionalCellData {
    var number: Holder<Int>
    
    static func cellData(number: Int) -> CellData {
        let customCellData = CustomCellData(number: Holder(number))
        return CellData(canEdit: false, canMove: false, canTap: false, cellIdentifier: .custom, additional: customCellData)
    }
}

// MARK: - EditCellData

struct EditCellData: AdditionalCellData {
    let isEditing: Alias<Bool>
    
    static func cellData(isEditing: Holder<Bool>) -> CellData {
        let editCellData = EditCellData(isEditing: Alias(isEditing))
        return CellData(canEdit: false, canMove: false, canTap: true, cellIdentifier: .edit, additional: editCellData)
    }
}
