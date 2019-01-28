//
//  TableSection.swift
//

import Foundation
import Chaining

final class TableSection {
    typealias CellDataArray = ArrayHolder<CellData>
    
    enum Event {
        case all([CellData], String?)
        case rows(CellDataArray.Event)
        case title(String?)
    }
    
    let title: ValueHolder<String?>
    let rows: CellDataArray
    
    private var pool = ObserverPool()
    
    convenience init() {
        self.init(title: nil, rows: [])
    }
    
    init(title: String?, rows: [CellData]) {
        self.title = ValueHolder(title)
        self.rows = ArrayHolder(rows)
        
        self.pool += self.rows.chain().to { .rows($0) }.receive(self).end()
        self.pool += self.title.chain().to { .title($0) }.receive(self).end()
    }
}

extension TableSection: Fetchable {
    typealias SendValue = Event
    
    func fetchedValue() -> Event? {
        return .all(self.rows.rawArray, self.title.value)
    }
}

extension TableSection: Receivable {
    func receive(value: Event) {
        self.broadcast(value: value)
    }
}
