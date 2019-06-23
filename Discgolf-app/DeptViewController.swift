//
//  DeptViewController.swift
//  Discgolf-app
//
//  Created by Glenn Olsson on 2019-06-23.
//  Copyright © 2019 Glenn Olsson. All rights reserved.
//

import Foundation
import UIKit

class DeptViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var depts: [Dept]!
    @IBOutlet weak var deptTableView: UITableView!
    
    override func viewDidLoad() {
        deptTableView.delegate = self
        deptTableView.dataSource = self
    }
    
    @objc func decreaseDeptPressed(sender: UIButton) {
        let dept = depts[sender.tag]
        dept.decrease()
        print("Decrease deptor \(dept.deptor.getName()) to \(dept.value)")
        if dept.value <= 0 {
            depts.remove(at: sender.tag)
        }
        deptTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeptCell", for: indexPath)
        let dept = depts[indexPath.row]
        
        
        let subviews = cell.contentView.subviews
        (subviews[0] as? UILabel)?.text = dept.getText()
        let decreaseButton = subviews[1] as? UIButton
        decreaseButton?.addTarget(self, action: #selector(decreaseDeptPressed(sender: )), for: UIControl.Event.touchUpInside)
        decreaseButton?.tag = indexPath.row //Set tag to dept index as Dept cannot be passed
        
        print("Added")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return depts.count > 0 ? depts.count : 0 // your number of cells here
    }
}
