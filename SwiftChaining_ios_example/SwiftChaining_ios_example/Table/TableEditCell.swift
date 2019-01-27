//
//  TableEditCell.swift
//

import UIKit
import Chaining

class TableEditCell: UITableViewCell {
    private var pool = ObserverPool()
    private var textAdapter: KVOAdapter<UILabel, String?>!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textAdapter = KVOAdapter(self.textLabel!, keyPath: \UILabel.text)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.pool.invalidate()
    }
}

extension TableEditCell: CellDataSettable {
    func set(cellData: CellData) {
        self.pool.invalidate()
        
        self.selectionStyle = cellData.canTap ? .default : .none
        
        if let editCellData = cellData.additional as? EditCellData {
            self.pool += editCellData.isEditing.chain().to { $0 ? "End Editing" : "Begin Editing" }.receive(self.textAdapter).sync()
        }
    }
}
