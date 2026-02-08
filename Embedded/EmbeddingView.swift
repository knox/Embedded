// Copyright (c) 2026 Mikolas Bingemer
// Licensed under the MIT License

import SwiftUI
import UIKit

struct EmbeddingView: View {
    @State private var isFullscreen = false
    @State private var viewController = EmbeddedViewController()
    @State private var containerSize: CGSize = .zero
    
    var embeddedHeight: CGFloat {
        containerSize.height / 3
    }

    var viewControllerHeight: CGFloat? {
        guard isFullscreen else { return embeddedHeight }
        return UIDevice.current.userInterfaceIdiom == .phone ? containerSize.width : containerSize.height
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Spacer().frame(height: embeddedHeight)

                Text("SwiftUI")
                    .font(.title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(isFullscreen ? 0 : 1)
            
            EmbeddedViewControllerRepresentable(
                viewController: viewController,
                isFullscreen: isFullscreen,
                onToggleTapped: {
                    withAnimation(.spring(duration: 0.3)) {
                        isFullscreen.toggle()
                    }
                }
            )
            .frame(height: viewControllerHeight)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { newSize in
            containerSize = newSize
        }
        .ignoresSafeArea()
    }
}

#Preview {
    EmbeddingView()
}
