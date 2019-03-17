//
//  TableEditCell.swift
//

import UIKit
import Chaining

struct EditCellData: CellData {
    let canEdit = false
    let canMove = false
    let canTap = false
    let cellIdentifier = "EditCell"
    
    let isEditing = ValueHolder<Bool>(false)
}

class TableEditCell: UITableViewCell {
    @IBOutlet weak var editingSwitch: UISwitch!
    
    private let pool = ObserverPool()

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.pool.invalidate()
    }
}

extension TableEditCell: CellDataSettable {
    func set(cellData: CellData) {
        self.pool.invalidate()
        
        guard let editCellData = cellData as? EditCellData else {
            fatalError()
        }
        
        editCellData.isEditing.chain()
            .sendTo(KVOAdapter(self.editingSwitch, keyPath: \.isOn).retain())
            .sync()
            .addTo(self.pool)
        
        UIControlAdapter(self.editingSwitch, events: .valueChanged)
            .retain()
            .chain()
            .map { $0.isOn }
            .sendTo(editCellData.isEditing)
            .end()
            .addTo(self.pool)
    }
}
