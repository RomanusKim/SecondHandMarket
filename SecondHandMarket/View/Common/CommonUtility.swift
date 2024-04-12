//
//  CommonUtility.swift
//  SecondHandMarket
//
//  Created by romanus on 4/12/24.
//

import Foundation
import UIKit

class CommonUtility {
    func goToViewController(identifier: String, navigationController: UINavigationController?) {
    
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: identifier)
        
        navigationController?.popToViewController(viewController, animated: true)
    }
}
