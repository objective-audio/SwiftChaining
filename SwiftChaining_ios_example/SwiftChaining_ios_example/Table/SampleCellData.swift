//
//  CellData.swift
//

import Foundation
import Chaining

enum CellIdentifier: String {
    case normal = "NormalCell"
    case custom = "CustomCell"
}

class CellData {
    let canEdit: Bool
    let canTap: Bool
    let cellIdentifier: CellIdentifier
    
    init(canEdit: Bool, canTap: Bool, cellIdentifier: CellIdentifier) {
        self.canEdit = canEdit
        self.canTap = canTap
        self.cellIdentifier = cellIdentifier
    }
}

protocol CellDataSettable {
    func set(cellData: CellData)
}

// MARK: - NormalCellData

class NormalCellData: CellData {
    let text: Holder<String>
    let detailText: Holder<String>
    
    init(text: String, detailText: String) {
        self.text = Holder(text)
        self.detailText = Holder(detailText)
        
        super.init(canEdit: true, canTap: true, cellIdentifier: .normal)
    }
}

// MARK: - CustomCellData

class CustomCellData: CellData {
    var number: Holder<Int>
    
    init(number: Int) {
        self.number = Holder(number)
        super.init(canEdit: false, canTap: false, cellIdentifier: .custom)
    }
}
