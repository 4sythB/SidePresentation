//
//  SideMenuAnimator.swift
//  SidePresentation
//
//  Created by Brad Forsyth on 10/8/19.
//  Copyright © 2019 Brad Forsyth. All rights reserved.
//

import UIKit


class SideMenuAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let isPresentation: Bool
    private var animator: UIViewPropertyAnimator?
    
    init(isPresentation: Bool) {
        self.isPresentation = isPresentation
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.interruptibleAnimator(using: transitionContext).startAnimation()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        
        let presentedKey = self.isPresentation ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from
        
        guard let presentedViewController = transitionContext.viewController(forKey: presentedKey) else { return UIViewPropertyAnimator() }
        
        if let animator = self.animator {
            return animator
        }
        
        if self.isPresentation {
            transitionContext.containerView.addSubview(presentedViewController.view)
        }
        
        let presentedViewPresentedFrame = transitionContext.finalFrame(for: presentedViewController)
        var presentedViewDismissedFrame = presentedViewPresentedFrame
        presentedViewDismissedFrame.origin.x = -presentedViewPresentedFrame.width
        
        let presentedViewIntialFrame = isPresentation ? presentedViewDismissedFrame : presentedViewPresentedFrame
        let presentedViewFinalFrame = isPresentation ? presentedViewPresentedFrame : presentedViewDismissedFrame
        
        presentedViewController.view.frame = presentedViewIntialFrame
        
        
        let animator = UIViewPropertyAnimator(duration: self.transitionDuration(using: transitionContext), curve: .linear) {
            // animate frame
            presentedViewController.view.frame = presentedViewFinalFrame
        }
        
        animator.addCompletion { (_) in
            if self.animator != nil {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                self.animator = nil
            }
        }
        
        self.animator = animator
        
        return animator
    }
}
