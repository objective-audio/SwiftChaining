//
//  SampleCustomCell.swift
//

import UIKit
import Chaining

class SampleCustomCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    private var labelAdapter: KVOAdapter<UILabel, String?>!
    private var stepperAdapter: KVOAdapter<UIStepper, Double>!
    
    private var pool = ObserverPool()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.labelAdapter = KVOAdapter(self.label, keyPath: \UILabel.text)
        self.stepperAdapter = KVOAdapter(self.stepper, keyPath: \UIStepper.value)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.pool.invalidate()
    }
}

extension SampleCustomCell: CellDataSettable {
    func set(cellData: CellData) {
        self.pool.invalidate()
        
        if let customCellData = cellData as? CustomCellData {
            self.pool += customCellData.number.chain().to { String($0) }.receive(self.labelAdapter).sync()
            self.pool += customCellData.number.chain().to { Double($0) }.receive(self.stepperAdapter).sync()
            self.pool += self.stepperAdapter.chain().to { Int($0) }.receive(customCellData.number).sync()
        }
    }
}
