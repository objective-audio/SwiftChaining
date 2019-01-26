//
//  TableViewCell.swift
//

import UIKit
import Chaining

class SampleNormalCell: UITableViewCell {
    private var pool = ObserverPool()
    private var textAlias: KVOAdapter<UILabel, String?>!
    private var detailTextAlias: KVOAdapter<UILabel, String?>!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textAlias = KVOAdapter(self.textLabel!, keyPath: \UILabel.text)
        self.detailTextAlias = KVOAdapter(self.detailTextLabel!, keyPath: \UILabel.text)
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
            self.pool += normalCellData.text.chain().to { String?($0) }.receive(self.textAlias).sync()
            self.pool += normalCellData.detailText.chain().to { String?($0) }.receive(self.detailTextAlias).sync()
        }
    }
}
