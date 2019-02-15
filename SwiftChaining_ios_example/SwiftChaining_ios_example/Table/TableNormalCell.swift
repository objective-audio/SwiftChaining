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
    private var pool = ObserverPool()
    private var textAdapter: KVOAdapter<UILabel, String?>!
    private var detailTextAdapter: KVOAdapter<UILabel, String?>!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textAdapter = KVOAdapter(self.textLabel!, keyPath: \UILabel.text)
        self.detailTextAdapter = KVOAdapter(self.detailTextLabel!, keyPath: \UILabel.text)
    }
    
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
        
        self.pool += normalCellData.text.chain().to { String?($0) }.sendTo(self.textAdapter).sync()
        self.pool += normalCellData.detailText.chain().to { String?($0) }.sendTo(self.detailTextAdapter).sync()
    }
}
