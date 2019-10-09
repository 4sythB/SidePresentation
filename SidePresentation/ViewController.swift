//
//  ViewController.swift
//  SidePresentation
//
//  Created by Brad Forsyth on 10/8/19.
//  Copyright © 2019 Brad Forsyth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func menuButtonTapped(_ sender: Any) {
        let sideMenu = SideMenuViewController.createFromStoryboard()
        self.present(sideMenu, animated: true, completion: nil)
    }
}
