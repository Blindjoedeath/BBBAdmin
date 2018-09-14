//
//  Functions.swift
//  BBBAdmin
//
//  Created by Blind Joe Death on 14.09.2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import Foundation
import UIKit

func networkErrorAlert() -> UIAlertController {
    let alert = UIAlertController(title: "Опа...",message:
        "Кажется твой интернет не так хорош, как твоя мама.",
                                  preferredStyle: .alert)
    
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    return alert
}
