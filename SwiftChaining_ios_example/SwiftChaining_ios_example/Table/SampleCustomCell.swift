//
//  SampleCustomCell.swift
//

import UIKit
import Chaining

class SampleCustomCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    private var labelAlias: KVOAdapter<UILabel, String?>!
    private var stepperAlias: KVOAdapter<UIStepper, Double>!
    
    private var pool = ObserverPool()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.labelAlias = KVOAdapter(self.label, keyPath: \UILabel.text)
        self.stepperAlias = KVOAdapter(self.stepper, keyPath: \UIStepper.value)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.pool.invalidate()
    }
}

extension SampleCustomCell: CellDataSettable {
    func set(cellData: AnyCellData) {
        self.pool.invalidate()
        
        if let customCellData = cellData as? CustomCellData {
            self.pool += customCellData.number.chain().to { String($0) }.receive(self.labelAlias).sync()
            self.pool += customCellData.number.chain().to { Double($0) }.receive(self.stepperAlias).sync()
            self.pool += self.stepperAlias.chain().to { Int($0) }.receive(customCellData.number).sync()
        }
    }
}
