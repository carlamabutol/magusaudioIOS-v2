//
//  VerticalProgressBar.swift
//  Magus
//
//  Created by Jomz on 11/9/23.
//

import UIKit
import RxRelay

class VerticalProgressBar: UIView {
    private let progressView = UIView()
    private let shadowView = UIView()
    private var panGesture: UIPanGestureRecognizer!
    
    let minimumProgress: CGFloat
    
    let progressRelay = PublishRelay<CGFloat>()

    var progress: CGFloat = 0 {
        didSet {
            updateProgressBar()
        }
    }

    init(minimumProgress: CGFloat) {
        self.minimumProgress = minimumProgress
        super.init(frame: .zero)
        setupProgressBar()
        setupPanGesture()
        progress = minimumProgress
    }

    required init?(coder: NSCoder) {
        self.minimumProgress = 0
        super.init(coder: coder)
        setupProgressBar()
        setupPanGesture()
    }
    
    var progressViewHeightConstraint: NSLayoutConstraint!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.applyShadow(offset: .zero)
    }

    private func setupProgressBar() {
        shadowView.backgroundColor = UIColor.white
        shadowView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(shadowView)
        addSubview(progressView)
        
        progressView.backgroundColor = UIColor.Background.primaryBlue
        progressView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: topAnchor, constant: 2.5),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2.5),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2.5),
            
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2.5),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2.5),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2.5),
        ])
        
        progressViewHeightConstraint = progressView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: progress, constant: -5)
        progressViewHeightConstraint.isActive = true
        shadowView.applyShadow(shadowOpacity: 1)
    }

    private func updateProgressBar() {
        progressViewHeightConstraint.isActive = false
        progressViewHeightConstraint = progressView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: progress, constant: -5)
        progressViewHeightConstraint.isActive = true
    }
    
    func setCornerRadius(_ radius: CGFloat) {
        cornerRadius(with: radius)
        progressView.cornerRadius(with: radius)
    }

    private func setupPanGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
    }
    
    var initialTranslation: CGPoint = CGPoint(x: 0, y: 0)

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        // You can adjust the sensitivity factor to control the speed reduction.
        let sensitivity: CGFloat = 0.5
        
        // Calculate the modified translation
        let modifiedTranslation = CGPoint(
            x: translation.x - (initialTranslation.x * sensitivity),
            y: translation.y - (initialTranslation.y * sensitivity)
        )
        
        initialTranslation = translation
        
        let newProgress = max(0, min(1, progress - modifiedTranslation.y / frame.height))
        if newProgress >= minimumProgress {
            progress = newProgress
            progressRelay.accept(newProgress)
        }

        if gesture.state == .ended {
            // You can handle any additional logic when the gesture ends here
        }
    }
}
