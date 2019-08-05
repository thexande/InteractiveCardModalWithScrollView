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
        let test = ModalViewController<DefaultCollectionContentViewController>(cardPresentationInteractor: interactor)
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

final class DefaultCollectionContentViewController: UICollectionViewController, ScrollViewProviding, UICollectionViewDelegateFlowLayout {
    
    var scrollView: UIScrollView? {
        return collectionView
    }
    
    func setContentInset(_ inset: UIEdgeInsets) {
        collectionView.contentInset = inset
        collectionView.scrollIndicatorInsets = inset
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UICollectionViewCell.self), for: indexPath)
        cell.backgroundColor = .green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 36) / 2
        return .init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 12, left: 12, bottom: 12, right: 12)
    }
}

