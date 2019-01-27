//
//  TableSection.swift
//

import Foundation
import Chaining

final class TableSection {
    enum Event {
        case all([AnyCellData], String?)
        case rows(ArrayHolder<AnyCellData>.Event)
        case title(String?)
    }
    
    let title: Holder<String?>
    let rows: ArrayHolder<AnyCellData>
    
    private var pool = ObserverPool()
    
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
    
    func fetchedValue() -> Event? {
        return .all(self.rows.rawArray, self.title.value)
    }
}

extension TableSection: Receivable {
    func receive(value: Event) {
        self.broadcast(value: value)
    }
}
