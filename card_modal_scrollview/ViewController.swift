import UIKit

class ViewController: UIViewController {
    
    private let interactor = CardPresentationInteractor()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "modal",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didSelectModal))
        
    }

    @objc private func didSelectModal() {
        let test = ModalViewController<TableContentViewController>(cardPresentationInteractor: interactor)
        test.transitioningDelegate = self
        present(test, animated: true, completion: nil)
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardDismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentAnimator()
    }
}

final class TableContentViewController: UITableViewController, ScrollViewProviding {
    var scrollView: UIScrollView? {
        return tableView
    }
}

