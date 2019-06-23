//
//  MainViewController.swift
//  Discgolf-app
//
//  Created by Glenn Olsson on 2019-06-19.
//  Copyright © 2019 Glenn Olsson. All rights reserved.
//

import Foundation
import UIKit

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

class MainViewController: UITableViewController {
	
    var rounds: [Game] = []
 
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@objc func statsPressed(sender: Any?){
		print("Pressed stats")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		print("Loaded")
        rounds = getRounds()
		
		
		
		let statsImage = UIImage(named: "Stats_button")
		
		let statsButton = UIBarButtonItem(image: statsImage, style: UIBarButtonItem.Style.plain, target: self, action: #selector(statsPressed(sender:)))
		self.navigationController?.navigationBar.topItem?.rightBarButtonItem = statsButton
    }
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? rounds.count * 2 : 0
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row % 2 == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "SeparatorCell", for: indexPath)
			return cell
		}
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "RoundCell", for: indexPath)
		let round = rounds[indexPath.row / 2]
		
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
		acView.frame.size = CGSize(width: 15, height: 20)
		
		cell.accessoryView = acView
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard indexPath.row % 2 == 0 else {
			return
		}
		
		let round = rounds[indexPath.row / 2]
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
	}
    
    

	/*
	// Override to support conditional editing of the table view.
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
	// Return false if you do not want the specified item to be editable.
	return true
	}
	*/
    
}
