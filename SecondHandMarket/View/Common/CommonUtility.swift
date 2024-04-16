//
//  CommonUtility.swift
//  SecondHandMarket
//
//  Created by romanus on 4/12/24.
//

import Foundation
import UIKit

extension UINavigationController {
    func goToViewController(identifier: String) {
    
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: identifier)
        self.popToViewController(viewController, animated: true)
//        switch identifier {
//        case "Home":
//            self.pushViewController(viewController, animated: true)
//        default:
//            self.popToViewController(viewController, animated: true)
//        }
    }
}

class CommonUtility {
    
}
