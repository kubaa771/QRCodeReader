//
//  CodesHistoryTableViewController.swift
//  QRCodeReader
//
//  Created by Jakub Iwaszek on 25/04/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import RealmSwift

class CodesHistoryTableViewController: UITableViewController {
    
    var allScannedCodes: Results<ScannedCode>! = nil
    var toAnimate: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        modelSetUp()
    }
    
    func modelSetUp() {
        toAnimate = true
        allScannedCodes = RealmDb.shared.getScannedCodes()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allScannedCodes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CodesHistoryCell", for: indexPath) as! CodesHistoryTableViewCell
        cell.model = allScannedCodes[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCellRow = allScannedCodes[indexPath.row]
        let alert = UIAlertController(title: "Code", message: selectedCellRow.metadata, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (action) in
            UIPasteboard.general.string = selectedCellRow.metadata
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let codeToDelete = allScannedCodes[indexPath.row]
            RealmDb.shared.deleteScannedCode(scannedCode: codeToDelete)
            modelSetUp()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if toAnimate {
            cell.alpha = 0
            UIView.animate(
                withDuration: 0.5,
                delay: 0.05 * Double(indexPath.row),
                animations: {
                    cell.alpha = 1
            })
            print(indexPath.row)
            if indexPath.row == allScannedCodes.count - 1{
                toAnimate = false
            }
        }
    }
    
}
