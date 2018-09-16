//
//  RjumanSpinnerView.swift
//  BBBAdmin
//
//  Created by Blind Joe Death on 16.09.2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import UIKit

class RjumanSpinnerView: UIView {
    
    private var isAnimating : Bool = false
    
    @IBOutlet weak var rjumanView : UIImageView! 
    
    private func animate(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear,
                       animations: {
                        self.rjumanView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        }, completion: {_ in
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear,
                           animations: {
                            self.rjumanView.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            }, completion: {_ in
                if self.isAnimating{
                    self.animate()
                }
            })
        })
    }
    
    func startAnimation(){
        if !isAnimating{
            isAnimating = true
            animate()
        }
        
    }
    
    func stopAnimation(){
        isAnimating = false
    }

}
