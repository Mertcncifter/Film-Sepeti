//
//  CustomInput.swift
//  Film Sepeti
//
//  Created by mert can çifter on 9.05.2022.
//

import UIKit

class CustomInput {
    func inputContainerView(withImage image : UIImage,textField : UITextField) -> UIView  {
        let view = UIView()
        
        let iv = UIImageView()

        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        iv.image = image
        iv.image?.withRenderingMode(.alwaysTemplate)
        
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor , bottom: view.bottomAnchor, paddingLeft: 8,paddingBottom: 8)
        iv.setDimensions(width: 24, height: 24)
        view.addSubview(textField)
        textField.anchor(left : iv.rightAnchor, bottom: view.bottomAnchor,
                         right: view.rightAnchor,paddingLeft: 8,paddingBottom: 8)
        let dividerView = UIView()
        dividerView.backgroundColor = .black
        view.addSubview(dividerView)
        dividerView.anchor(left : view.leftAnchor, bottom: view.bottomAnchor,right: view.rightAnchor,
                           paddingLeft:  8,height: 0.75)
        
        return view
    }
    
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.textColor = .black
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder,attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        return tf
    }

}
