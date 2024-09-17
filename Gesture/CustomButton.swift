//
//  CustomButton.swift
//  Click&Count
//
//  Created by 陳信彰 on 2024/9/17.
//
import UIKit

class ImageButton: UIButton {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // Custom Button
        configurationUpdateHandler = { button in
            
            // 當button被按住就會變更alpha值
            button.alpha = button.isHighlighted ? 0.5 : 1
            
        }
        
    }
    
    
}
