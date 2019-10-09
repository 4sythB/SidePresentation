//
//  ViewController.swift
//  SidePresentation
//
//  Created by Brad Forsyth on 10/8/19.
//  Copyright © 2019 Brad Forsyth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var interactor: SideMenuInteractiveTransition!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor = SideMenuInteractiveTransition()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation: CGPoint = gestureRecognizer.translation(in: self.view)
        let velocity = gestureRecognizer.velocity(in: self.view).x
        
        let progress = interactor.calculateProgress(translationInView: translation, viewBounds: self.view.bounds, direction: .right)
        
        interactor.mapGestureStateToInteractor(gestureState: gestureRecognizer.state, progress: progress, velocity: velocity) {
            presentMenu()
        }
    }

    @IBAction func menuButtonTapped(_ sender: Any) {
        presentMenu()
    }
    
    private func presentMenu() {
        let sideMenu = SideMenuViewController.createFromStoryboard()
        sideMenu.transitioningDelegate = self
        self.present(sideMenu, animated: true, completion: nil)
    }
}


extension ViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let pc = SideMenuPresentationController(presentedViewController: presented, presenting: presenting)
        pc.interactor = self.interactor
        return pc
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SideMenuAnimator(isPresentation: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SideMenuAnimator(isPresentation: false)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactor.hasStarted ? self.interactor : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactor.hasStarted ? self.interactor : nil
    }
}
