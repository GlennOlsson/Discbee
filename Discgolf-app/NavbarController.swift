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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if self.titleTextAttributes == nil {
            self.titleTextAttributes = [:]
        }
        
        self.titleTextAttributes![NSAttributedString.Key.kern] = 5
    }
    
}
