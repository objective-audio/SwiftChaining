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
    
    private let pool = ObserverPool()
    
    convenience init() {
        self.init(title: nil, rows: [])
    }
    
    init(title: String?, rows: [CellData]) {
        self.title = ValueHolder(title)
        self.rows = ArrayHolder(rows)
        
        self.rows.chain().map { .rows($0) }.sendTo(self).end().addTo(self.pool)
        self.title.chain().map { .title($0) }.sendTo(self).end().addTo(self.pool)
    }
}

extension TableSection: Syncable {
    typealias ChainValue = Event
    
    func fetchedValue() -> Event {
        return .all(self.rows.raw, self.title.value)
    }
}

extension TableSection: Receivable {
    func receive(value: Event) {
        self.broadcast(value: value)
    }
}
