//
//  CellData.swift
//

import Foundation
import SwiftChaining

enum CellIdentifier: String {
    case normal = "NormalCell"
    case custom = "CustomCell"
}

class AnyCellData {
    let canEdit: Bool
    var cellIdentifier: CellIdentifier
    
    init(canEdit: Bool, cellIdentifier: CellIdentifier) {
        self.canEdit = canEdit
        self.cellIdentifier = cellIdentifier
    }
}

extension AnyCellData: Relayable {
    typealias SendValue = AnyCellData
}

protocol CellDataSettable {
    func set(cellData: AnyCellData)
}

// MARK: - NormalCellData

class NormalCellData: AnyCellData {
    let text: Holder<String>
    let detailText: Holder<String>
    
    init(text: String, detailText: String) {
        self.text = Holder(text)
        self.detailText = Holder(detailText)
        
        super.init(canEdit: true, cellIdentifier: .normal)
    }
}

// MARK: - CustomCellData

class CustomCellData: AnyCellData {
    var number: Holder<Int>
    
    init(number: Int) {
        self.number = Holder(number)
        super.init(canEdit: false, cellIdentifier: .custom)
    }
}
