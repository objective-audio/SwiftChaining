//
//  TableViewCell.swift
//

import UIKit
import Chaining

class SampleNormalCell: UITableViewCell {
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

extension SampleNormalCell: CellDataSettable {
    func set(cellData: AnyCellData) {
        self.pool.invalidate()
        
        if let normalCellData = cellData as? NormalCellData {
            self.pool += normalCellData.text.chain().to { String?($0) }.receive(self.textAdapter).sync()
            self.pool += normalCellData.detailText.chain().to { String?($0) }.receive(self.detailTextAdapter).sync()
        }
    }
}
