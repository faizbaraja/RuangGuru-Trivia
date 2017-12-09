//
//  BorderedView.swift
//  RuangGuru Trivia
//
//  Created by Faiz Umar Baraja on 09/12/2017.
//  Copyright © 2017 FaizBarajaApps. All rights reserved.
//

import UIKit

class BorderedView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func layoutSubviews() {
        let borderColor = UIColor.black
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5
    }
}
