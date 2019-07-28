import UIKit

final class PresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let dim = UIView()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else {
                return
        }
        let containerView = transitionContext.containerView
        // overlay the modal on top of the ViewController
        containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
        // stage the modal VC one screen below
        toVC.view.center.y += UIScreen.main.bounds.height
        // the fromVC (ViewController) is going away.
        // give the illusion of it still being on the screen.
        guard let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false) else { return }
        containerView.insertSubview(snapshot, belowSubview: toVC.view)
        
        containerView.insertSubview(dim, belowSubview: toVC.view)
        dim.backgroundColor = .clear
        dim.frame = containerView.frame
        
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: {
                        // center the modal on the screen
                        toVC.view.center.y = UIScreen.main.bounds.height / 2
                        self.dim.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                        
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}


//class PresentAnimator : NSObject, UIViewControllerAnimatedTransitioning {
//    // property for keeping the animator for current ongoing transition
//    private var animatorForCurrentTransition: UIViewImplicitlyAnimating?
//    private let dim = UIView()
//
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return 0.5
//    }
//
//    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
//        // as per documentation, the same object should be returned for the ongoing transition
//        if let animatorForCurrentSession = animatorForCurrentTransition {
//            return animatorForCurrentSession
//        }
//        // normal creation of the propertyAnimator
//        guard
//            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
//            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
//            else {
//                return UIViewPropertyAnimator()
//        }
//
//        let containerView = transitionContext.containerView
//        // overlay the modal on top of the ViewController
//        containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
//        // stage the modal VC one screen below
//        toVC.view.center.y += UIScreen.main.bounds.height
//        // the fromVC (ViewController) is going away.
//        // give the illusion of it still being on the screen.
//        guard let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false) else { return UIViewPropertyAnimator() }
//        containerView.insertSubview(snapshot, belowSubview: toVC.view)
//
//        containerView.insertSubview(dim, belowSubview: toVC.view)
//        dim.frame = containerView.frame
//        dim.backgroundColor = .clear
//
//
////        view_To.alpha = 0
//        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), curve: .linear)
//
//        animator.addAnimations {
////            view_To.alpha = 1
////            view_From.alpha = 0
//            toVC.view.center.y = UIScreen.main.bounds.height / 2
//            self.dim.backgroundColor = UIColor.black.withAlphaComponent(0.3)
//        }
//        animator.addCompletion { (position) in
//            switch position {
//            case .end:
//                print("Completion handler called at end of animation")
//            case .current:
//                print("Completion handler called mid-way through animation")
//            case .start:
//                print("Completion handler called  at start of animation")
//            }
//            // transition completed, reset the current animator:
//            self.animatorForCurrentTransition = nil
//
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
//        // keep the reference to current animator
//        self.animatorForCurrentTransition = animator
//        return animator
//    }
//
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        // animateTransition should work too, so let's just use the interruptibleAnimator implementation to achieve it
//        let anim = self.interruptibleAnimator(using: transitionContext)
//        anim.startAnimation()
//    }
//}
