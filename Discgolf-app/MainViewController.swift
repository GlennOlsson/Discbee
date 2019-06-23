//
//  MainViewController.swift
//  Discgolf-app
//
//  Created by Glenn Olsson on 2019-06-19.
//  Copyright © 2019 Glenn Olsson. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UITableViewController {
	
    var rounds: [Game] = []
 
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@objc func statsPressed(sender: Any?){
		print("Pressed stats")
		performSegue(withIdentifier: "StatsSegue", sender: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		print("Loaded")
        rounds = getRounds()
		
		self.tableView.separatorColor = UIColor.black

		
		(self.navigationController?.navigationBar as? NavbarController)?.enableStatsButton(target: self, action: #selector(statsPressed(sender:)))
    }
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		print("NR of sections")
		return 2
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print("Section: \(section)")
		switch section {
		case 0:
			return rounds.filter({(game: Game) -> Bool in game.isLive}).count
		case 1:
			return rounds.filter({(game: Game) -> Bool in !game.isLive}).count
		default:
			return 0
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "RoundCell", for: indexPath)
		let round = rounds[indexPath.row]
		
		let subViews = cell.contentView.subviews
		var subLabels = subViews.map({(view: UIView) -> UILabel? in
			guard let label = view as? UILabel else {
				return nil
			}
			return label
		}) //Make all UIViews -> UILabels
		
		subLabels[0]!.text = round.location
		subLabels[1]!.text = round.getTime()
		
		//Accessory view, the > arrow on each cell
		let acView = UIView()
		var acImage = UIImage(named: "Accessory_Arrow")
		acImage = acImage?.rotate(radians: .pi / 2)
		acView.layer.contents = acImage?.cgImage
		acView.frame.size = CGSize(width: 10, height: 20)
		cell.accessoryView = acView
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let round = rounds[indexPath.row]
		print(round.location)
//		let cell = tableView.cellForRow(at: indexPath)
//		cell?.contentView.subviews[0].layer.borderWidth = 2
////		cell?.contentView.subviews[0].layer.borderColor = CGColor
		performSegue(withIdentifier: "RoundDetailedSegue", sender: round)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let roundDetailedVS = segue.destination as? RoundDetailedVC{
			guard let round = sender as? Game else {
				print("No game!")
				self.title = "ERROR"
				return
			}
			roundDetailedVS.round = round
			print("Set round")
		}
		
		if let deptsVS = segue.destination as? DeptViewController{
			deptsVS.depts = getDepts()
			print("Set depts")
		}
	}
	
	override func tableView(_: UITableView, titleForHeaderInSection: Int) -> String? {
		return titleForHeaderInSection == 0 ? "Active" : "Finished"
	}
}

//Copyright Ratul Sharker, https://stackoverflow.com/a/48781122/8138631
extension UIImage {
	func rotate(radians: CGFloat) -> UIImage {
		let rotatedSize = CGRect(origin: .zero, size: size)
			.applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
			.integral.size
		UIGraphicsBeginImageContext(rotatedSize)
		if let context = UIGraphicsGetCurrentContext() {
			let origin = CGPoint(x: rotatedSize.width / 2.0,
								 y: rotatedSize.height / 2.0)
			context.translateBy(x: origin.x, y: origin.y)
			context.rotate(by: radians)
			draw(in: CGRect(x: -origin.y, y: -origin.x,
							width: size.width, height: size.height))
			let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			
			return rotatedImage ?? self
		}
		
		return self
	}
}
