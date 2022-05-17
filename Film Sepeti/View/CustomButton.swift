//
//  CustomButotn.swift
//  Film Sepeti
//
//  Created by mert can çifter on 9.05.2022.
//

import UIKit

class CustomButton {
    
    func attributedButton(_ firstPart: String, _ secondPart: String) ->UIButton {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes:
            [NSMutableAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
            NSMutableAttributedString.Key.foregroundColor: UIColor.black])
        
        attributedTitle.append(NSMutableAttributedString(string: secondPart, attributes:
            [NSMutableAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
            NSMutableAttributedString.Key.foregroundColor: UIColor.black
            ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }

}
