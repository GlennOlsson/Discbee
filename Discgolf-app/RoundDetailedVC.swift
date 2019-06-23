//
//  RoundDetailedVC.swift
//  Discgolf-app
//
//  Created by Glenn Olsson on 2019-06-20.
//  Copyright © 2019 Glenn Olsson. All rights reserved.
//

import Foundation
import UIKit

class RoundDetailedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var round: Game!
    @IBOutlet weak var EventView: UIView!
    @IBOutlet weak var EventTable: UITableView!
    @IBOutlet weak var ResumeButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = round.location
        print("loaded")
        
        EventTable.delegate = self
        EventTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = round.events[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        let subViews = cell.contentView.subviews
        var subLabels = subViews.map({(view: UIView) -> UILabel? in
            guard let label = view as? UILabel else {
                return nil
            }
            return label
        }) //Make all UIViews -> UILabels
        subLabels[0]!.text = event.getTime()
        subLabels[1]!.text = event.player.getName()
        subLabels[2]!.text = String(event.action)
        
        print("Added")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return round.events.count > 0 ? round.events.count : 0 // your number of cells here
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.white
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}
