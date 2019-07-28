import UIKit

final class PresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
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
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: {
                        // center the modal on the screen
                        toVC.view.center.y = UIScreen.main.bounds.height / 2
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
