import UIKit

class CardPresentationController: PresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        print(containerView.bounds.size.height)
        let percent = containerView.bounds.height * 0.25
        let top = containerView.bounds.height - percent
        return containerView.bounds
            .inset(by: UIEdgeInsets(top: containerView.bounds.height - top, left: 0, bottom: 0, right: 0))
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        presentedView?.layer.cornerRadius = 0
        containerView?.backgroundColor = .clear

        if let coordinator = presentingViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { [weak self] _ in
                self?.containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                }, completion: nil)
        }
    }

    override func dismissalTransitionWillBegin() {
        if let coordinator = presentingViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { [weak self] _ in
                self?.containerView?.backgroundColor = .clear
            }, completion: nil)
        }
    }
}
