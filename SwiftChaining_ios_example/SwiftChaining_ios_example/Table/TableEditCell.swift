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
    
    private var switchIsOnAdapter: KVOAdapter<UISwitch, Bool>!
    private var switchChangedAdapter: UIControlAdapter<UISwitch>!
    private var pool = ObserverPool()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.switchIsOnAdapter = KVOAdapter(self.editingSwitch, keyPath: \UISwitch.isOn)
        self.switchChangedAdapter = UIControlAdapter(self.editingSwitch, events: .valueChanged)
    }

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
        
        self.pool += editCellData.isEditing.chain().sendTo(self.switchIsOnAdapter).sync()
        self.pool += self.switchChangedAdapter.chain().map { $0.isOn }.sendTo(editCellData.isEditing).end()
    }
}
