//
//  SideMenuInteractiveTransition.swift
//  SidePresentation
//
//  Created by Brad Forsyth on 10/9/19.
//  Copyright © 2019 Brad Forsyth. All rights reserved.
//

import UIKit


enum SwipeDirection: Int {
    case left
    case right
}

class SideMenuInteractiveTransition: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
    let percentThreshold: CGFloat = 0.3
    
    func calculateProgress(translationInView: CGPoint, viewBounds: CGRect, direction: SwipeDirection) -> CGFloat {
        let pointOnAxis: CGFloat
        let axisLength: CGFloat
        
        switch direction {
        case .left, .right:
            pointOnAxis = translationInView.x
            axisLength = viewBounds.width
        }
        
        let movementOnAxis = pointOnAxis / axisLength
        let positiveMovementOnAxis: Float
        let positiveMovementOnAxisPercent: Float
        
        switch direction {
        case .right : // positive
            positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
            positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
            return CGFloat(positiveMovementOnAxisPercent)
        case .left: // negative
            positiveMovementOnAxis = fminf(Float(movementOnAxis), 0.0)
            positiveMovementOnAxisPercent = fmaxf(positiveMovementOnAxis, -1.0)
            return CGFloat(-positiveMovementOnAxisPercent)
        }
    }
    
    func mapGestureStateToInteractor(gestureState: UIGestureRecognizer.State, progress: CGFloat, velocity: CGFloat, triggerSegue: () -> Void) {
        if gestureState != .began && progress < 0 {
            cancel()
            return
        }
        
        switch gestureState {
        case .began:
            hasStarted = true
            triggerSegue()
        case .changed:
            if (hasStarted == false) {
                hasStarted = true
                triggerSegue()
            }
            
            shouldFinish = progress > percentThreshold
            self.update(progress)
        case .cancelled:
            hasStarted = false
            self.cancel()
        case .ended:
            hasStarted = false
            if velocity > 500 {
                self.finish()
            } else {
                shouldFinish ? finish() : cancel()
            }
        default:
            break
        }
    }
}
