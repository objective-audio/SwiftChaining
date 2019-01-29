//
//  TableViewCell.swift
//

import UIKit
import Chaining

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
        
        self.selectionStyle = normalCellData.canTap ? .default : .none
        self.pool += normalCellData.text.chain().to { String?($0) }.receive(self.textAdapter).sync()
        self.pool += normalCellData.detailText.chain().to { String?($0) }.receive(self.detailTextAdapter).sync()
    }
}
