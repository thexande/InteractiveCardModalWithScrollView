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
        let test = ModalViewController<NavigationWrappedTable>(cardPresentationInteractor: interactor)
        test.transitioningDelegate = self
        present(test, animated: true, completion: nil)
    }
}

final class NavigationWrappedTable: NavigationController<TableContentViewController> {
    
}

class NavigationController<Wrapped: UIViewController & ScrollViewProviding>: UINavigationController, ScrollViewProviding {
    
    var scrollView: UIScrollView? {
        return wrapped.scrollView
    }
    
    func setContentInset(_ inset: UIEdgeInsets) {
        wrapped.setContentInset(inset)
    }
    
    
    let wrapped = Wrapped()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([wrapped], animated: false)
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

final class TableContentViewController: UITableViewController, ScrollViewProviding {
    
    var scrollView: UIScrollView? {
        return tableView
    }
    
    func setContentInset(_ inset: UIEdgeInsets) {
        tableView.contentInset = inset
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        title = "Demo"
        navigationItem.leftBarButtonItem = .init(title: "Close", style: .done, target: self, action: #selector(didSelectClose))
    }
    
    @objc private func didSelectClose() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self)) else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = "Section \(indexPath.section ), Item \(indexPath.item)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let test = UIViewController()
        test.view.backgroundColor = .red
        
        navigationController?.pushViewController(test, animated: true)
    }
}
