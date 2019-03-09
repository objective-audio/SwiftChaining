//
//  TableViewController.swift
//

import UIKit
import Chaining

class TableViewController: UITableViewController {
    let controller: TableController = TableController()
    
    let pool = ObserverPool()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.controller.sections.chain().do({ [weak self] event in
            switch event {
            case .fetched, .any:
                self?.tableView.reloadData()
            case .inserted(let section, _):
                self?.tableView.insertSections(IndexSet(integer: section), with: .automatic)
            case .removed(let section, _):
                self?.tableView.deleteSections(IndexSet(integer: section), with: .automatic)
            case .replaced(let section, _):
                self?.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            case .moved:
                self?.tableView.reloadData()
            case .relayed(let sectionEvent, let section, _):
                switch sectionEvent {
                case .all, .title:
                    self?.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
                case .rows(let rowEvent):
                    switch rowEvent {
                    case .fetched, .set:
                        self?.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
                    case .inserted(let row, _):
                        self?.tableView.insertRows(at: [IndexPath(row: row, section: section)], with: .automatic)
                    case .removed(let row, _):
                        self?.tableView.deleteRows(at: [IndexPath(row: row, section: section)], with: .automatic)
                    case .moved:
                        self?.tableView.reloadData()
                    case .replaced(let row, let cellData):
                        if let cell = self?.tableView.cellForRow(at: IndexPath(row: row, section: section)) as? CellDataSettable {
                            cell.set(cellData: cellData)
                        }
                    }
                }
            }
        }).sync().addTo(self.pool)
        
        self.controller.isEditing.chain().do { [weak self] isEditing in self?.setEditing(isEditing, animated: true) }.sync().addTo(self.pool)
        
        self.controller.showAlertNotifier
            .chain()
            .do { [weak self] alertData in
                let alert = UIAlertController(title: alertData.title,
                                              message: alertData.message,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }.end().addTo(self.pool)
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
        let cellData = self.controller.cellData(for: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellData.cellIdentifier, for: indexPath)
        
        cell.selectionStyle = cellData.canTap ? .default : .none
        
        if let cell = cell as? CellDataSettable {
            cell.set(cellData: cellData)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.controller.cellData(for: indexPath).canEdit
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return self.controller.cellData(for: indexPath).canEdit
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.controller.removeRow(at: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.controller.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.controller.cellTapped(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.controller.accessoryTapped(at: indexPath)
    }
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        self.controller.addRow()
    }
}
