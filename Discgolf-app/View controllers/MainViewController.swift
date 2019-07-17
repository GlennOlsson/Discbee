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
	
	var addButton: UIButton?

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
		
		self.tableView.separatorStyle = .singleLine
		self.tableView.separatorColor = UIColor(red: 0.74, green: 0.87, blue: 0.91, alpha: 1)
		
		let window = UIApplication.shared.keyWindow!
		let button = UIButton()
		addButton = button
		
		print(window.subviews)
		
		window.addSubview(button)
		
		button.setImage(UIImage(named: "New Game Button"), for: .normal)
		
		//Button shadow
		let buttonLayer = button.layer
		var buttonFrame = button.frame
		buttonFrame.size = CGSize(width: 50, height: 50)
		buttonLayer.shadowRadius = 4
		buttonLayer.shadowOpacity = 0.5
		buttonLayer.shadowOffset = CGSize(width: 5, height: 5)
		
		//Button location
		button.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: window, attribute: .bottom, multiplier: 1, constant: -20).isActive = true
		NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal, toItem: window, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
		
		button.addTarget(self, action: #selector (addButtonPressed(sender:)), for: .touchUpInside)
		
		(self.navigationController?.navigationBar as? NavbarController)?.enableStatsButton(target: self, action: #selector(statsPressed(sender:)))
    }
	
	@objc func addButtonPressed(sender: UIButton?) {
		print("add pressed")
//		setAddIsHidden(true)
	}
	
	func setAddIsHidden(_ isHidden: Bool){
		if let button = addButton {
			let animation = UIViewPropertyAnimator(duration: 0.2, curve: .linear, animations: {				
				//Pan to left if going to hide, back to original if going to show
				let window = UIApplication.shared.keyWindow!.frame
				let frame = button.frame
				if !isHidden {
					button.center = CGPoint(x: window.width - 50, y: window.height - 50)
				}
				else {
					button.center.x = -frame.width
				}
			})
			animation.startAnimation()
		}
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
		
		//TODO: Fix animation for add button to disapear
//		cell.selectionStyle = .none
		print("SelectedView: \(cell.selectedBackgroundView)")
		let selectedView = UIView()
		selectedView.backgroundColor = UIColor(red: 0.478, green: 0.769, blue: 0.788, alpha: 0.9)
//		selectedView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
		cell.selectedBackgroundView = selectedView
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print(indexPath.row)
		let round = indexPath.section == 0 ? ongoingRounds[indexPath.row] : finishedRounds[indexPath.row]
		print(round.location)
		performSegue(withIdentifier: "RoundDetailedSegue", sender: round)
		tableView.cellForRow(at: indexPath)?.isSelected = false
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		print("Will app")
		setAddIsHidden(false)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		//Hide add button on right side so animation back is quicker and better looking
		addButton?.center.x = UIApplication.shared.keyWindow!.frame.width + 50
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		print("Prepare")
		setAddIsHidden(true)
		if let roundDetailedVS = segue.destination as? RoundDetailedVC{
			guard let round = sender as? Game else {
				print("No game!")
				self.title = "ERROR"
				return
			}
			roundDetailedVS.round = round
			print("Set round")
		}
		
		else if let deptsVS = segue.destination as? DeptViewController{
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
