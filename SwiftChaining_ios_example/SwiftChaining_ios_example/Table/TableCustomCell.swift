//
//  TableCustomCell.swift
//

import UIKit
import Chaining

struct CustomCellData: CellData {
    let canEdit = false
    let canMove = false
    let canTap = false
    let cellIdentifier = "CustomCell"
    
    var number: ValueHolder<Int>
    
    init(number: Int) {
        self.number = ValueHolder(number)
    }
}

class TableCustomCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    private let pool = ObserverPool()

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.pool.invalidate()
    }
}

extension TableCustomCell: CellDataSettable {
    func set(cellData: CellData) {
        self.pool.invalidate()
        
        let customCellData = cellData as! CustomCellData
        
        customCellData.number.chain()
            .map { String($0) }
            .sendTo(KVOAdapter(self.label, keyPath: \.text).retain())
            .sync().addTo(self.pool)
        
        let retainedStepperAdapter = KVOAdapter(self.stepper, keyPath: \.value).retain()
        
        customCellData.number.chain()
            .map { Double($0) }
            .sendTo(retainedStepperAdapter)
            .sync().addTo(self.pool)
        
        retainedStepperAdapter.chain()
            .map { Int($0) }
            .sendTo(customCellData.number)
            .sync().addTo(self.pool)
    }
}
