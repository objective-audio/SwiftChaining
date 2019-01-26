//
//  TableController.swift
//

import Foundation
import Chaining

class TableController {
    typealias SectionArray = RelayableArrayHolder<TableSection>
    
    let sections: SectionArray
    
    init() {
        let section0 = TableSection(title: "Section 0", rows:[CustomCellData(number: 10)])
        let section1 = TableSection(title: "Section 1", rows:[])
        self.sections = SectionArray([section0, section1])
    }
    
    func addRow() {
        let index = self.sections[1].rows.count
        let cellData = NormalCellData(text: "cell \(index)", detailText: "detail \(index)")
        self.sections[1].rows.append(cellData)
    }
    
    func removeRow(at indexPath: IndexPath) {
        self.sections[indexPath.section].rows.remove(at: indexPath.row)
    }
}
