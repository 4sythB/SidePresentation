//
//  SideMenuViewController.swift
//  SidePresentation
//
//  Created by Brad Forsyth on 10/8/19.
//  Copyright © 2019 Brad Forsyth. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBlue
    }
    
    class func createFromStoryboard() -> SideMenuViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "sideMenu") as! SideMenuViewController
        vc.modalPresentationStyle = .custom
        
        return vc
    }
}
