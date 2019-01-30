//
//  TableController.swift
//

import Foundation
import Chaining

class TableController {
    typealias SectionArray = RelayableArrayHolder<TableSection>
    
    let sections: SectionArray
    let isEditing: Alias<ValueHolder<Bool>>
    
    struct AlertData {
        let title: String
        let message: String
    }
    
    let showAlertNotifier = Notifier<AlertData>()
    
    init() {
        let editCellData = EditCellData()
        self.isEditing = Alias(editCellData.isEditing)
        
        let section0 = TableSection(title: "Section 0",
                                    rows:[CustomCellData(number: 1), editCellData])
        let section1 = TableSection(title: "Section 1",
                                    rows:[NormalCellData(index: 0),
                                          NormalCellData(index: 1),
                                          NormalCellData(index: 2)])
        self.sections = SectionArray([section0, section1])
    }
    
    func cellData(for indexPath: IndexPath) -> CellData {
        return self.sections[indexPath.section].rows[indexPath.row]
    }
    
    func addRow() {
        let index = self.sections[1].rows.count
        let cellData = NormalCellData(index: index)
        self.sections[1].rows.append(cellData)
    }
    
    func removeRow(at indexPath: IndexPath) {
        self.sections[indexPath.section].rows.remove(at: indexPath.row)
    }
    
    func moveRow(at from: IndexPath, to: IndexPath) {
        if from.section == to.section {
            self.sections[from.section].rows.move(at: from.row, to: to.row)
        }
    }
    
    func cellTapped(at indexPath: IndexPath) {
        let cellData = self.cellData(for: indexPath)
        if cellData.canTap, let normalCellData = cellData as? NormalCellData {
            let message = "Cell Tapped\n\(normalCellData.text.value) \(normalCellData.detailText.value)\nIndexPath:\(indexPath)"
            self.showAlertNotifier.notify(value: AlertData(title: "Table Example", message: message))
        }
    }
    
    func accessoryTapped(at indexPath: IndexPath) {
        let cellData = self.cellData(for: indexPath)
        if let normalCellData = cellData as? NormalCellData {
            let message = "Accesorry Tapped\n\(normalCellData.text.value) \(normalCellData.detailText.value)\nIndexPath:\(indexPath)"
            self.showAlertNotifier.notify(value: AlertData(title: "Table Example", message: message))
        }
    }
}
