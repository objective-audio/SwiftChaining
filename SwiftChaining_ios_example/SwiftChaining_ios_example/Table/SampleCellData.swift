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
    var cellIdentifier: CellIdentifier
    
    init(canEdit: Bool, cellIdentifier: CellIdentifier) {
        self.canEdit = canEdit
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
        
        super.init(canEdit: true, cellIdentifier: .normal)
    }
}

// MARK: - CustomCellData

class CustomCellData: CellData {
    var number: Holder<Int>
    
    init(number: Int) {
        self.number = Holder(number)
        super.init(canEdit: false, cellIdentifier: .custom)
    }
}
