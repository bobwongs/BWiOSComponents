//
//  BWHomeViewController.swift
//  BWiOSComponentsSwift
//
//  Created by BobWong on 2017/12/26.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

import UIKit

let KeyTitle = "KeyTitle"
let KeySegueId = "KeySegueId"

let CellId = "CellId"


class BWHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource: [Dictionary<String, Any>]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let addressPickerDict = [KeyTitle: "BWAddressPicker", KeySegueId: "home_to_address_picker"]
        let circulationRollingDict = [KeyTitle: "BWCirculationRolling", KeySegueId: "home_to_ circulation_rolling"]
        self.dataSource = [addressPickerDict, circulationRollingDict]
        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataSource != nil) ? self.dataSource!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: CellId)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: CellId)
        }
        cell?.textLabel?.text = self.dataSource?[indexPath.row][KeyTitle] as? String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.performSegue(withIdentifier: self.dataSource?[indexPath.row][KeySegueId] as! String, sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.title = self.dataSource?[sender as! Int][KeyTitle] as? String
    }

}
