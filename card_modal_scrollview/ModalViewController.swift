import UIKit
import Anchorage

protocol ScrollViewProviding {
    var scrollView: UIScrollView? { get }
    func setContentInset(_ inset: UIEdgeInsets)
}

protocol ViewRendering {
    associatedtype Properties
    func render(_ properties: Properties)
}

final class ModalHeaderView: UIView, ViewRendering {
    
    struct Properties {
        
    }
    
    func render(_ properties: Properties) {
        
    }
    
    private let indicator = UIView()
    private let background = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private var indicatorWidthConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(background)
        background.edgeAnchors == edgeAnchors
        
        addSubview(indicator)
        indicator.topAnchor == topAnchor + 12
        indicator.centerXAnchor == centerXAnchor
        indicator.backgroundColor = .darkGray
        indicator.heightAnchor == 4
        indicator.layer.cornerRadius = 2
        indicatorWidthConstraint = indicator.widthAnchor == 56
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setIndicatorWidth(_ offset: CGFloat) {
        let width = abs(56 * (120 / offset)) - 56
        print(width)
        if width > 12 {
            indicatorWidthConstraint.constant = width
        }
    }
}

final class ModalViewController<ContentViewController: UIViewController & ScrollViewProviding>: UIViewController {
    
    private let contentViewController = ContentViewController()
    private let contentView = UIView()
    private let spacer = UIView()
    private let header = ModalHeaderView()
    private let interactor: CardPresentationInteractor
    let headerHeight: CGFloat = 64

    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewController.scrollView?.panGestureRecognizer.addTarget(self, action: #selector(scrollViewDidScroll(_:)))
        view.isOpaque = false
        view.backgroundColor = .clear
        spacer.backgroundColor = .clear
        header.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:))))
        
        view.addSubview(spacer)
        spacer.translatesAutoresizingMaskIntoConstraints = false
        
        spacer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        spacer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        spacer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        spacer.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: spacer.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        header.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        header.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: headerHeight).isActive = true
        
        header.clipsToBounds = true
        header.layer.cornerRadius = 12
        header.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 12
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
        
        addContentViewController(contentViewController)
        
    }
    
    init(cardPresentationInteractor: CardPresentationInteractor) {
        self.interactor = cardPresentationInteractor
        super.init(nibName: nil, bundle: nil)
        contentViewController.setContentInset(.init(top: headerHeight, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addContentViewController(_ contentViewController: UIViewController) {
        addChild(contentViewController)
        contentViewController.willMove(toParent: self)
        
        contentView.addSubview(contentViewController.view)
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        contentViewController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        contentViewController.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        contentViewController.view.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        contentViewController.view.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        contentViewController.didMove(toParent: self)
    }
    
    @objc private func scrollViewDidScroll(_ sender: UIPanGestureRecognizer) {
        guard let offset = (sender.view as? UIScrollView)?.contentOffset.y else { return }
        let absoluteOffset = abs(offset)
       
        if absoluteOffset > 120 {
            dismiss(animated: true, completion: nil)
        }
        
        header.setIndicatorWidth(absoluteOffset)
    }
    
    @objc private func handleGesture(_ sender: UIPanGestureRecognizer) {
        
        let percentThreshold:CGFloat = 0.3
        
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / contentView.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }
}
