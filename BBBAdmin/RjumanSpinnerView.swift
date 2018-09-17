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
    private var stopCompletion : (() -> Void)?
    
    @IBOutlet weak var rjumanView : UIImageView!
    
    private func animate(){
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear,
                       animations: {
                        self.rjumanView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }, completion: {_ in
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear,
                           animations: {
                                self.rjumanView.transform = CGAffineTransform(rotationAngle: CGFloat(0))
                            }, completion: {_ in
                                if self.isAnimating{
                                    self.animate()
                                } else {
                                    self.stopAnimation()
                                }
                            })
        })
    }
    
    private func stopAnimation(){
        if let completion = stopCompletion{
            completion()
        }
    }
    
    func startAnimation(){
        if !isAnimating {
            isAnimating = true
            animate()
        }
    }
    
    func stopAnimation(completion : @escaping () -> Void){
        stopCompletion = completion
        isAnimating = false
    }
}
