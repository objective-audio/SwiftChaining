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
    
    private lazy var switchIsOnAdapter = { KVOAdapter(self.editingSwitch, keyPath: \.isOn) }()
    private lazy var switchChangedAdapter = { UIControlAdapter(self.editingSwitch, events: .valueChanged) }()
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
        
        editCellData.isEditing.chain().sendTo(self.switchIsOnAdapter).sync().addTo(self.pool)
        self.switchChangedAdapter.chain().map { $0.isOn }.sendTo(editCellData.isEditing).end().addTo(self.pool)
    }
}
