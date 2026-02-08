// Copyright (c) 2026 Mikolas Bingemer
// Licensed under the MIT License

import SwiftUI
import UIKit

// MARK: - EmbeddedViewControllerRepresentable

struct EmbeddedViewControllerRepresentable: UIViewControllerRepresentable {
    let viewController: EmbeddedViewController
    let isFullscreen: Bool
    let onToggleTapped: () -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        viewController.onToggleTapped = onToggleTapped
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        viewController.isFullscreen = isFullscreen
    }
}

// MARK: - EmbeddedViewController

final class EmbeddedViewController: UIViewController {
    var onToggleTapped: (() -> Void)?
    var isFullscreen: Bool = false {
        didSet {
            guard oldValue != isFullscreen else { return }
            updateButtonIcon()
            requestOrientation(isFullscreen ? .landscape : .portrait)
        }
    }
    
    private func requestOrientation(_ orientation: UIInterfaceOrientationMask) {
        guard UIDevice.current.userInterfaceIdiom == .phone else { return }
        let windowScene = view.window?.windowScene
        let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: orientation)
        windowScene?.requestGeometryUpdate(geometryPreferences) { error in
            print("requestGeometryUpdate \(orientation) error: \(error)")
        }
        setNeedsUpdateOfSupportedInterfaceOrientations()
    }
    
    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemYellow
        button.tintColor = .label
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let image = UIImage(systemName: "arrow.up.left.and.arrow.down.right", withConfiguration: config)
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "UIKit"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        
        view.addSubview(contentLabel)
        view.addSubview(toggleButton)
        
        NSLayoutConstraint.activate([
            contentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            toggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toggleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60),
            toggleButton.widthAnchor.constraint(equalToConstant: 50),
            toggleButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        toggleButton.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
    }
    
    @objc private func toggleButtonTapped() {
        onToggleTapped?()
    }
    
    private func updateButtonIcon() {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        let iconName = isFullscreen ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right"
        let image = UIImage(systemName: iconName, withConfiguration: config)
        toggleButton.setImage(image, for: .normal)
    }
}
