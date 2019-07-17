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
    
    @objc func statsPressed(sender: Any?){
        print("Pressed stats")
        performSegue(withIdentifier: "StatsSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = round.location
        print("loaded")
		
		addResumeButton()
        
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
	
	@objc func resumePressed(sender: Any?) {
		print("Pressed resume")
		round.resume()
		performSegue(withIdentifier: "ActiveGameSegue", sender: self)
	}
	
	func addResumeButton(){
		let resumeButton = UIButton(type: .custom)
		resumeButton.setTitle("Resume", for: .normal)
		resumeButton.layer.cornerRadius = 10
		resumeButton.titleLabel!.font = UIFont(name: "GillSans-Light", size: 27)
		resumeButton.backgroundColor = UIColor(red: 0.35, green: 0.69, blue: 0.8, alpha: 1)
		
		self.view.addSubview(resumeButton)
		
		resumeButton.addTarget(self, action: #selector(resumePressed(sender:)), for: .touchUpInside)
		
		resumeButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint(item: resumeButton, attribute: .top, relatedBy: .equal, toItem: EventView, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
		NSLayoutConstraint(item: resumeButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
		NSLayoutConstraint(item: resumeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 125).isActive = true
		NSLayoutConstraint(item: resumeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
		
		print("Added resume button")
	}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let resumeVC = segue.destination as? ActiveRoundViewController {
            resumeVC.round = round
        }
    }
}
