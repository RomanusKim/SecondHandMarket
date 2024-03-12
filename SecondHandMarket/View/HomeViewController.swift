//
//  HomeViewController.swift
//  SecondHandMarket
//
//  Created by romanus on 3/12/24.
//

import UIKit

class HomeViewController: UIViewController {

    
    // Subject로 바꿀것인가 그냥 둘것인가
    var address = UserDefaults.standard.string(forKey: "Address")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("HomeViewController Addrss : \(address)")
    }

}
