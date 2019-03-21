//
//  TableViewCell.swift
//

import UIKit
import Chaining

struct NormalCellData: CellData {
    let canEdit = true
    let canMove = true
    let canTap = true
    let cellIdentifier = "NormalCell"
    
    let text: ValueHolder<String>
    let detailText: ValueHolder<String>
    
    init(text: String, detailText: String) {
        self.text = ValueHolder(text)
        self.detailText = ValueHolder(detailText)
    }
    
    init(index: Int) {
        self.init(text: "cell \(index)", detailText: "detail \(index)")
    }
}

class TableNormalCell: UITableViewCell {
    private let pool = ObserverPool()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.pool.invalidate()
    }
}

extension TableNormalCell: CellDataSettable {
    func set(cellData: CellData) {
        self.pool.invalidate()
        
        guard let normalCellData = cellData as? NormalCellData else {
            fatalError()
        }
        
        normalCellData.text.chain()
            .map { String($0) }
            .sendTo(KVOAdapter(self.textLabel!, keyPath: \.text).retain())
            .sync().addTo(self.pool)
        
        normalCellData.detailText.chain()
            .map { String($0) }
            .sendTo(KVOAdapter(self.detailTextLabel!, keyPath: \.text).retain())
            .sync().addTo(self.pool)
    }
}
