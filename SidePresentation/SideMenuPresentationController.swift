//
//  SideMenuPresentationController.swift
//  SidePresentation
//
//  Created by Brad Forsyth on 10/8/19.
//  Copyright © 2019 Brad Forsyth. All rights reserved.
//

import UIKit


let menuWidth: CGFloat = 0.8

class SideMenuPresentationController: UIPresentationController {
    
    var interactor: SideMenuInteractiveTransition?
    private var dimmingView: UIView!
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        setupDimmingView()
    }
    
    private func setupDimmingView() {
        self.dimmingView = UIView()
        self.dimmingView.translatesAutoresizingMaskIntoConstraints = false
        self.dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.dimmingView.alpha = 0.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        self.dimmingView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        self.dimmingView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: presentedViewController.view)
        let velocity = -(recognizer.velocity(in: self.dimmingView).x)
        
        let progress = interactor?.calculateProgress(translationInView: translation,
                                                        viewBounds: presentedViewController.view.bounds,
                                                        direction: .left)
        
        interactor?.mapGestureStateToInteractor(gestureState: recognizer.state, progress: progress ?? 0, velocity: velocity) {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    override func presentationTransitionWillBegin() {
        guard let container = self.containerView else { return }
        if container.subviews.contains(self.dimmingView) == false {
            container.insertSubview(self.dimmingView, at: 0)
        }
        
        self.dimmingView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        self.dimmingView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        self.dimmingView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        self.dimmingView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
        guard let coordinator = presentedViewController.transitionCoordinator else { return }
        
        coordinator.animate(alongsideTransition: { (_) in
            self.dimmingView.alpha = 1.0
            self.presentedViewController.view.backgroundColor = .green
        })
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        guard let coordinator = presentedViewController.transitionCoordinator else { return }
        
        if coordinator.isCancelled {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else { return }
        
        coordinator.animate(alongsideTransition: { (_) in
            self.dimmingView.alpha = 0.0
            self.presentedViewController.view.backgroundColor = .blue
        })
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        let width = parentSize.width * menuWidth
        
        return CGSize(width: width, height: parentSize.height)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let frameSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView?.bounds.size ?? .zero)
        let frame = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        return frame
    }
}
