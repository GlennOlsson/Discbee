//
//  NavbarController.swift
//  Discgolf-app
//
//  Created by Glenn Olsson on 2019-06-19.
//  Copyright © 2019 Glenn Olsson. All rights reserved.
//

import Foundation
import UIKit

class NavbarController: UINavigationBar {
    override func willChangeValue(forKey key: String) {
        print("Change val \(key)")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func enableStatsButton(target: Any?, action: Selector){
        //The stats button
        let statsImage = UIImage(named: "Stats_button")
        let statsButton = UIBarButtonItem(image: statsImage, style: UIBarButtonItem.Style.plain, target: target, action: action)
        self.topItem?.rightBarButtonItem = statsButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if self.titleTextAttributes == nil {
            self.titleTextAttributes = [:]
        }
        
        self.titleTextAttributes![NSAttributedString.Key.kern] = 5
    }
    
    @objc func statsPressed(sender: Any?){
        print("Pressed stats")
//        performSegue(withIdentifier: "StatsSegue", sender: nil)
    }
}
