import UIKit

final class ViewController: UIViewController {
    
    private let interactor = CardPresentationInteractor()
    private let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        view.backgroundColor = .white
        button.addTarget(self, action: #selector(presentModal), for: .touchUpInside)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        button.heightAnchor.constraint(equalToConstant: 65).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.setTitle("Present Modal", for: .normal)
    }

    @objc private func presentModal() {
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
    
    func setContentInset(_ inset: UIEdgeInsets) {
        tableView.contentInset = inset
    }
}

