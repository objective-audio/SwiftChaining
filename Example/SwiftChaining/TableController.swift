//
//  TableController.swift
//

import Foundation
import Chaining

final class TableSection {
    enum Event {
        case all([AnyCellData], String?)
        case rows(ArrayHolder<AnyCellData>.Event)
        case title(String?)
    }
    
    let core = SenderCore<TableSection>()
    
    let title: Holder<String?>
    let rows: ArrayHolder<AnyCellData>
    
    var pool = ObserverPool()
    
    convenience init() {
        self.init(title: nil, rows: [])
    }
    
    init(title: String?, rows: [AnyCellData]) {
        self.title = Holder(title)
        self.rows = ArrayHolder(rows)
        
        self.pool += self.rows.chain().to { .rows($0) }.receive(self).end()
        self.pool += self.title.chain().to { .title($0) }.receive(self).end()
    }
}

extension TableSection: Fetchable {
    typealias SendValue = Event
    
    func fetchedValue() -> TableSection.SendValue {
        return .all(self.rows.rawArray, self.title.value)
    }
}

extension TableSection: Receivable {
    func receive(value: TableSection.Event) {
        self.broadcast(value: value)
    }
}

class TableController {
    typealias SectionArray = ArrayHolder<TableSection>
    
    let sections: SectionArray
    
    init() {
        let section0 = TableSection(title: "Section 0", rows:[CustomCellData(number: 10)])
        let section1 = TableSection(title: "Section 1", rows:[])
        self.sections = ArrayHolder([section0, section1])
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
