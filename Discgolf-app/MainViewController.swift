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
	var finishedRounds: [Game] = []
	var ongoingRounds: [Game] = []
 
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
		
        refresh()
		
		self.tableView.backgroundColor = UIColor(red: 0.74, green: 0.87, blue: 0.91, alpha: 1)
		
		(self.navigationController?.navigationBar as? NavbarController)?.enableStatsButton(target: self, action: #selector(statsPressed(sender:)))
    }
	
	func refresh(){
		rounds = getRounds()
		finishedRounds = rounds.filter({(game: Game) -> Bool in !game.isLive})
		ongoingRounds = rounds.filter({(game: Game) -> Bool in game.isLive})
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		print("NR of sections")
		return 2
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print("Section: \(section)")
		switch section {
		case 0:
			return ongoingRounds.count
		case 1:
			return finishedRounds.count
		default:
			return 0
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "RoundCell", for: indexPath)
		
		let round = indexPath.section == 0 ? ongoingRounds[indexPath.row] : finishedRounds[indexPath.row]
		
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
		
		cell.selectionStyle = .none
		let selectedView = cell.selectedBackgroundView ?? UIView()
		selectedView.backgroundColor = UIColor.red //UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.55)
		cell.selectedBackgroundView = selectedView
		
		//Separator between cells
		let separator = UIView()
		separator.frame = CGRect(x: 0, y: cell.frame.height - 2, width: cell.frame.width, height: 5)
		separator.backgroundColor = UIColor(red: 0.74, green: 0.87, blue: 0.91, alpha: 1)
		cell.contentView.addSubview(separator)
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print(indexPath.row)
		let round = indexPath.section == 0 ? ongoingRounds[indexPath.row] : finishedRounds[indexPath.row]
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
