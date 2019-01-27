//
//  TableEditCell.swift
//

import UIKit
import Chaining

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
        
        self.selectionStyle = cellData.canTap ? .default : .none
        
        if let editCellData = cellData.additional as? EditCellData {
            self.pool += editCellData.isEditing.chain().receive(self.switchIsOnAdapter).sync()
            self.pool += self.switchChangedAdapter.chain().to { $0.isOn }.receive(editCellData.isEditing).do { value in print("switch value : \(value)") }.end()
        }
    }
}
