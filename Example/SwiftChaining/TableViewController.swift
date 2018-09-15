//
//  TableViewController.swift
//

import UIKit
import Chaining

extension Optional: Relayable {
    public typealias SendValue = Optional
}

class TableViewController: UITableViewController {
    let controller: TableController = TableController()
    
    var pool = ObserverPool()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pool += self.controller.sections.chain().do({ [weak self] event in
            switch event {
            case .fetched, .any:
                self?.tableView.reloadData()
            case .inserted(let section, _):
                self?.tableView.insertSections(IndexSet(integer: section), with: .automatic)
            case .removed(let section, _):
                self?.tableView.deleteSections(IndexSet(integer: section), with: .automatic)
            case .replaced(let section, _):
                self?.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            case .relayed(let sectionEvent, let section, _):
                switch sectionEvent {
                case .all, .title:
                    self?.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
                case .rows(let rowEvent):
                    switch rowEvent {
                    case .fetched, .any:
                        self?.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
                    case .inserted(let row, _):
                        self?.tableView.insertRows(at: [IndexPath(row: row, section: section)], with: .automatic)
                    case .removed(let row, _):
                        self?.tableView.deleteRows(at: [IndexPath(row: row, section: section)], with: .automatic)
                    case .replaced(let row, let cellData), .relayed(_, let row, let cellData):
                        if let cell = self?.tableView.cellForRow(at: IndexPath(row: row, section: section)) as? CellDataSettable {
                            cell.set(cellData: cellData)
                        }
                    }
                }
            }
        }).sync()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.controller.sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.controller.sections[section].title.value
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.controller.sections[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = self.cellData(for: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellData.cellIdentifier.rawValue, for: indexPath)
        
        if let cell = cell as? CellDataSettable {
            cell.set(cellData: cellData)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.cellData(for: indexPath).canEdit
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.controller.removeRow(at: indexPath)
        }
    }
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        self.controller.addRow()
    }
}

extension TableViewController /* private */ {
    private func cellData(for indexPath: IndexPath) -> AnyCellData {
        return self.controller.sections[indexPath.section].rows[indexPath.row]
    }
}
