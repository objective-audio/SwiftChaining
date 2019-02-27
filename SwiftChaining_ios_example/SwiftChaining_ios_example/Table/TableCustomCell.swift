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
    
    private lazy var labelAdapter = { KVOAdapter(self.label, keyPath: \.text) }()
    private lazy var stepperAdapter = { KVOAdapter(self.stepper, keyPath: \.value) }()
    
    private var pool = ObserverPool()

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.pool.invalidate()
    }
}

extension TableCustomCell: CellDataSettable {
    func set(cellData: CellData) {
        self.pool.invalidate()
        
        guard let customCellData = cellData as? CustomCellData else {
            fatalError()
        }
        
        self.pool += customCellData.number.chain().map { String($0) }.sendTo(self.labelAdapter).sync()
        self.pool += customCellData.number.chain().map { Double($0) }.sendTo(self.stepperAdapter).sync()
        self.pool += self.stepperAdapter.chain().map { Int($0) }.sendTo(customCellData.number).sync()
    }
}
