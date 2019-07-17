//
//  ActiveRoundVC.swift
//  Discgolf-app
//
//  Created by Glenn Olsson on 2019-06-24.
//  Copyright © 2019 Glenn Olsson. All rights reserved.
//

import Foundation
import UIKit

class ActiveRoundViewController: UIViewController {
    
    @IBOutlet weak var scoreView: UIView!
	var buttonViewContainer: UIView!
	
    var round: Game!
    @IBOutlet weak var contentView: UIView!
    
    var tempScoreDiff: [Player: Int] = [:]
    var playerViews: [Player: UIView] = [:]
	
	var totalHeight: CGFloat = 0
    
    override func viewDidLoad() {
        self.title = round.location
		
		totalHeight += 20 //Top margin
        addScoreboard()
		totalHeight += 50 //Margin between scoreboard and button view
        addScoreButtons()
		totalHeight += 50 //Margin between button view and finish button
		addResumeButton()
		totalHeight += 50 //Bottom margin
		
		print("total height: \(totalHeight)")
		
		contentView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: totalHeight).isActive = true
    }
    
    func updateDiffLabel(label: UILabel, val: Int){
        label.text = String(val)
    }
    
    @objc func addPressed(sender: ScoreButton?){
        guard let scoreButton = sender else {
            fatalError("ADD WITH NO SENDER")
        }
        let player = scoreButton.player
        if tempScoreDiff[player] == nil {
            tempScoreDiff[player] = 0
        }
        else {
            tempScoreDiff[player]! += 1
        }
        updateDiffLabel(label: scoreButton.diffLabel, val: tempScoreDiff[player]!)
        print("temp score diff: \(tempScoreDiff[player]!)")
    }
    
    @objc func subtractPressed(sender: ScoreButton?){
        guard let scoreButton = sender else {
            fatalError("SUBTRACT WITH NO SENDER")
        }
        let player = scoreButton.player
        if tempScoreDiff[player] == nil {
            tempScoreDiff[player] = 0
        }
        else {
            tempScoreDiff[player]! -= 1
        }
        updateDiffLabel(label: scoreButton.diffLabel, val: tempScoreDiff[player]!)
        print("temp score diff: \(tempScoreDiff[player]!)")
    }
    
    @objc func donePressed(sender: ScoreButton?){
        /* TODO:
                    User timer of a few minutes to automatically save diff
        */
        
        guard let scoreButton = sender else {
            fatalError("DONE WITH NO SENDER")
        }
		handleSaveAction(button: scoreButton)
    }
	
	func handleSaveAction(button: ScoreButton){
		let player = button.player
		guard let currentDiff = tempScoreDiff[player] else {
			print("Done but no diff registered")
			return
		}
		round.score[player]! += currentDiff
		tempScoreDiff[player] = 0
		updateDiffLabel(label: button.diffLabel, val: 0)
		print("New score by diff: \(currentDiff)")
		(playerViews[player]?.subviews[1] as? UILabel)?.text = String(round.score[player]!) //Will be looong if wrapped in if statements
		round.addEvent(player: player, action: currentDiff)
	}
	
	@objc func finishPressed(sender: Any?){
		print("Pressed finish")
	}
    
    func addScoreboard(){
        var totalHeight: CGFloat = 30 + 20 //Height of first view + first margin + some extra
        for (player, score) in round.score {
            let nameLabel = CustomLabel()
            let scoreLabel = CustomLabel()
            
            nameLabel.text = player.getName()
            scoreLabel.text = String(score)
            
            nameLabel.sizeToFit()
            scoreLabel.sizeToFit()
            
            let playerView = UIView()
            playerView.addSubview(nameLabel)
            playerView.addSubview(scoreLabel)
            
            playerViews[player] = playerView
            
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            scoreLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: playerView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: scoreLabel, attribute: .trailing, relatedBy: .equal, toItem: playerView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
            
            playerView.frame.size.height = max(nameLabel.frame.height, scoreLabel.frame.height)
            
            let siblingView = scoreView.subviews.last
            scoreView.addSubview(playerView)
            playerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: playerView, attribute: .leading, relatedBy: .equal, toItem: scoreView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: playerView, attribute: .trailing, relatedBy: .equal, toItem: scoreView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: playerView, attribute: .top, relatedBy: .equal, toItem: siblingView, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
            
            print("Added \(player.getName()) with \(score) points")
            totalHeight += playerView.frame.size.height
        }
        NSLayoutConstraint(item: scoreView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: totalHeight).isActive = true
		self.totalHeight += totalHeight
    }
    
    func addScoreButtons(){
        
        buttonViewContainer = UIView()
        contentView.addSubview(buttonViewContainer)
        buttonViewContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: buttonViewContainer!, attribute: .top, relatedBy: .equal, toItem: scoreView!, attribute: .bottom, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: buttonViewContainer!, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: buttonViewContainer!, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        buttonViewContainer.sizeToFit()
        contentView.setNeedsDisplay()
        
        var index = 0
        var height = 0
         for (player, _) in round.score {
            let view = UIView()
            buttonViewContainer.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            let siblings = buttonViewContainer.subviews
            let constraint: (view: UIView, const: CGFloat, attribute: NSLayoutConstraint.Attribute) = index > 0 ? (view: siblings[index - 1], const: 20, attribute: NSLayoutConstraint.Attribute.bottom) : (view: buttonViewContainer, const: 0, attribute: NSLayoutConstraint.Attribute.top)
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: constraint.view, attribute: constraint.attribute, multiplier: 1, constant: constraint.const).isActive = true
            NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: buttonViewContainer, attribute: .leading, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: buttonViewContainer, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
            view.sizeToFit()
            
            let nameLabel = CustomLabel()
            view.addSubview(nameLabel)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.text = player.getName()
            nameLabel.sizeToFit()
            
            let horizontalLine = UIView()
            view.addSubview(horizontalLine)
            horizontalLine.translatesAutoresizingMaskIntoConstraints = false
            horizontalLine.backgroundColor = UIColor.white
            NSLayoutConstraint(item: horizontalLine, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: horizontalLine, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: horizontalLine, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: horizontalLine, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1).isActive = true
            
            print(horizontalLine.frame)
            
            let buttonView = UIView()
            view.addSubview(buttonView)
            buttonView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: buttonView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: buttonView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: buttonView, attribute: .top, relatedBy: .equal, toItem: horizontalLine, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
            NSLayoutConstraint(item: buttonView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
            
            let addButton = ScoreButton(title: "+", player: player)
            buttonView.addSubview(addButton)
            addButton.translatesAutoresizingMaskIntoConstraints = false
            addButton.addTarget(self, action: #selector(addPressed(sender:)), for: .touchUpInside)
            NSLayoutConstraint(item: addButton, attribute: .leading, relatedBy: .equal, toItem: buttonView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: addButton, attribute: .top, relatedBy: .equal, toItem: buttonView, attribute: .top, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: addButton, attribute: .bottom, relatedBy: .equal, toItem: buttonView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
			addButton.setBackgroundImage(UIImage(named: "Add button"), for: .normal)
            
            let subtractButton = ScoreButton(title: "-", player: player)
            buttonView.addSubview(subtractButton)
            subtractButton.translatesAutoresizingMaskIntoConstraints = false
            subtractButton.addTarget(self, action: #selector(subtractPressed(sender:)), for: .touchUpInside)
            NSLayoutConstraint(item: subtractButton, attribute: .centerX, relatedBy: .equal, toItem: buttonView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: subtractButton, attribute: .top, relatedBy: .equal, toItem: buttonView, attribute: .top, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: subtractButton, attribute: .bottom, relatedBy: .equal, toItem: buttonView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
			subtractButton.setBackgroundImage(UIImage(named: "Subtract button"), for: .normal)
            
            let doneButton = ScoreButton(title: "✓", player: player)
            buttonView.addSubview(doneButton)
            doneButton.translatesAutoresizingMaskIntoConstraints = false
            doneButton.addTarget(self, action: #selector(donePressed(sender:)), for: .touchUpInside)
            NSLayoutConstraint(item: doneButton, attribute: .trailing, relatedBy: .equal, toItem: buttonView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: doneButton, attribute: .top, relatedBy: .equal, toItem: buttonView, attribute: .top, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: doneButton, attribute: .bottom, relatedBy: .equal, toItem: buttonView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
			doneButton.setBackgroundImage(UIImage(named: "Done button"), for: .normal)
            
            let diffScoreLabel = CustomLabel()
            diffScoreLabel.text = "0"
            buttonView.addSubview(diffScoreLabel)
            diffScoreLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: diffScoreLabel, attribute: .leading, relatedBy: .equal, toItem: addButton, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: diffScoreLabel, attribute: .centerY, relatedBy: .equal, toItem: buttonView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: diffScoreLabel, attribute: .trailing, relatedBy: .equal, toItem: subtractButton, attribute: .leading, multiplier: 1, constant: 0).isActive = true
            diffScoreLabel.textAlignment = .center
            
            addButton.diffLabel = diffScoreLabel
            subtractButton.diffLabel = diffScoreLabel
            doneButton.diffLabel = diffScoreLabel
            
            print("Added \(player.getName()) with buttons")
            index += 1
            view.sizeToFit()
            height += 100 + 20 //view height + top constraint
        }
        NSLayoutConstraint(item: buttonViewContainer!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(height)).isActive = true
		
		self.totalHeight += CGFloat(height)
    }
	
	func addResumeButton(){
		let finishButton = UIButton(type: .custom)
		finishButton.setTitle("Finish", for: .normal)
		finishButton.layer.cornerRadius = 10
		finishButton.titleLabel!.font = UIFont(name: "GillSans-Light", size: 27)
		finishButton.backgroundColor = UIColor(red: 0.35, green: 0.69, blue: 0.8, alpha: 1)
		
		contentView.addSubview(finishButton)
		
		finishButton.addTarget(self, action: #selector(finishPressed(sender:)), for: .touchUpInside)
		
		finishButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint(item: finishButton, attribute: .top, relatedBy: .equal, toItem: buttonViewContainer, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
		NSLayoutConstraint(item: finishButton, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
		NSLayoutConstraint(item: finishButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 125).isActive = true
		NSLayoutConstraint(item: finishButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
		
		print("Added finish button")
		
		totalHeight += 50
	}
}

class ScoreButton: UIButton {
    
    var player: Player
    var diffLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    init(title: String, player: Player){
        self.player = player
        super.init(frame: .zero)
        frame.size = CGSize(width: 50, height: 50)
    }
}
