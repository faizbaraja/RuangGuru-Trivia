//
//  CollectionViewCellAnswers.swift
//  RuangGuru Trivia
//
//  Created by Faiz Umar Baraja on 09/12/2017.
//  Copyright © 2017 FaizBarajaApps. All rights reserved.
//

import UIKit

class CollectionViewCellAnswers: UICollectionViewCell {
    @IBOutlet var labelAnswerText:UILabel!
    @IBOutlet var labelAnswerCorrectness:UILabel!
    @IBOutlet var labelAnswerCharacter:UILabel!
    @IBOutlet var viewBackground:BorderedView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
