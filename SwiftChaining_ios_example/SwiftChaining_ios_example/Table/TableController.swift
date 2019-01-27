//
//  TableController.swift
//

import Foundation
import Chaining

class TableController {
    typealias SectionArray = RelayableArrayHolder<TableSection>
    
    let sections: SectionArray
    
    struct AlertData {
        let title: String
        let message: String
    }
    
    let showAlertNotifier = Notifier<AlertData>()
    
    init() {
        let section0 = TableSection(title: "Section 0", rows:[CustomCellData.cellData(number: 1)])
        let section1 = TableSection(title: "Section 1", rows:[])
        self.sections = SectionArray([section0, section1])
    }
    
    func cellData(for indexPath: IndexPath) -> CellData {
        return self.sections[indexPath.section].rows[indexPath.row]
    }
    
    func addRow() {
        let index = self.sections[1].rows.count
        let cellData = NormalCellData.cellData(text: "cell \(index)", detailText: "detail \(index)")
        self.sections[1].rows.append(cellData)
    }
    
    func removeRow(at indexPath: IndexPath) {
        self.sections[indexPath.section].rows.remove(at: indexPath.row)
    }
    
    func moveRow(at from: IndexPath, to: IndexPath) {
        if from.section == to.section {
            self.sections[from.section].rows.move(from: from.row, to: to.row)
        }
    }
    
    func cellTapped(at indexPath: IndexPath) {
        let cellData = self.sections[indexPath.section].rows[indexPath.row]
        if cellData.canTap {
            self.showAlertNotifier.notify(value: AlertData(title: "Table Example", message: "cellTapped"))
        }
    }
    
    func accessoryTapped(at indexPath: IndexPath) {
        let cellData = self.sections[indexPath.section].rows[indexPath.row]
        if cellData.canTap {
            self.showAlertNotifier.notify(value: AlertData(title: "Table Example", message: "accessoryTapped"))
        }
    }
}
