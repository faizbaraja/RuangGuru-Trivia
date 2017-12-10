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
    
    func setCellBasicMode(){
        viewBackground.backgroundColor = UIColor.white
        labelAnswerCharacter.textColor = UIColor.lightGray
        labelAnswerCorrectness.textColor = UIColor.lightGray
        labelAnswerText.textColor = UIColor.lightGray
        labelAnswerCorrectness.isHidden = true
    }
    
    func setCellCorrectMode(){
        viewBackground.backgroundColor = UIColorData.getColorCorrectGreen()
        labelAnswerCharacter.textColor = UIColorData.getColorCorrectGreen()
        labelAnswerCorrectness.textColor = UIColor.white
        labelAnswerText.textColor = UIColor.white
        labelAnswerCorrectness.isHidden = false
    }
    
    func setCellInCorrectMode(){
        viewBackground.backgroundColor = UIColorData.getColorInCorrectRed()
        labelAnswerCharacter.textColor = UIColorData.getColorInCorrectRed()
        labelAnswerCorrectness.textColor = UIColor.white
        labelAnswerText.textColor = UIColor.white
        labelAnswerCorrectness.isHidden = false
    }

}
