//
//  NetworkingViewManager.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 6/9/23.
//

import UIKit

/// Provides functionality to manage various views that could be needed in the context of networking.
/// Includes methods to show and dismiss a loading view and an empty state view.
/// Requires a parent view controller. The views will be overlayed on top of the parent view controller's view.
class NetworkingViewsManager {
    private var loadingView = UIView()
    private var emptyStateView: EmptyStateView?
    
    weak var parentViewController: UIViewController?
    
    init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
    }
    
    func showLoadingView() {
        guard let parentView = parentViewController?.view else { return }
        
        loadingView = UIView(frame: parentView.bounds)
        parentView.addSubview(loadingView)
        
        loadingView.backgroundColor = .systemBackground
        loadingView.alpha = 0
        
        UIView.animate(withDuration: 0.25) { self.loadingView.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        loadingView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        self.loadingView.removeFromSuperview()
        self.loadingView = UIView()
    }
    
    func showEmptyStateView(emptyState: EmptyStateView.EmptyState) {
        guard emptyStateView == nil, let parentView = parentViewController?.view else {
            return
        }
        
        emptyStateView = EmptyStateView(emptyState: emptyState)
        
        let emptyStateView = emptyStateView!
        
        parentView.addSubview(emptyStateView)
        
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyStateView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: -50),
            emptyStateView.heightAnchor.constraint(equalTo: parentView.heightAnchor, multiplier: 0.7)
        ])
    }
    
    func dismissEmptyStateView() {
        emptyStateView?.removeFromSuperview()
        emptyStateView = nil
    }
}
