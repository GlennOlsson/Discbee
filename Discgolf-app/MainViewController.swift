//
//  MainViewController.swift
//  Discgolf-app
//
//  Created by Glenn Olsson on 2019-06-19.
//  Copyright © 2019 Glenn Olsson. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded")
        fixTitle()
        
        
    }
    
    func fixTitle(){
        
        let view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 114, height: 34)
        view.backgroundColor = .white
        
        view.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        view.font = UIFont(name: "OpenSans-Regular", size: 25)
        
        // Line height: 34 pt
        // (identical to box height)
        
        view.text = "Rounds"
        
        let parent = UIView()
        parent.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 114).isActive = true
        view.heightAnchor.constraint(equalToConstant: 34).isActive = true
        view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 130).isActive = true
        view.topAnchor.constraint(equalTo: parent.topAnchor, constant: 13).isActive = true

        
//        self.navigationController?.navigationItem.titleView = parent
//        self.navigationController?.navigationBar.isHidden = false
		
		
		
		var bar = self.navigationController?.navigationBar as! NavbarController
		bar.setTitle("Hello, world")
		
        
//        titleView.tintColor = UIColor.white
//        titleView.backgroundColor = UIColor(red: 0.35, green: 0.69, blue: 0.8, alpha: 1)
    }
    
}
