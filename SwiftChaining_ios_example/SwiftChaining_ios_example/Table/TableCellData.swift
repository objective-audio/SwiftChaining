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
