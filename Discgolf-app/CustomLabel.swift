//
//  CustomLabel.swift
//  Discgolf-app
//
//  Created by Glenn Olsson on 2019-07-08.
//  Copyright © 2019 Glenn Olsson. All rights reserved.
//

import Foundation
import UIKit

class CustomLabel: UILabel {
    init(){
        super.init(frame: .zero)
        self.font = UIFont(name: "Gill Sans", size: 17)
        self.textColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        print(aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}
