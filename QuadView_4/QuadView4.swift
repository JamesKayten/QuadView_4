//
//  QuadView4.swift
//  QuadView_4
//
//  Created by Smallfavor on 11/2/23.
//

import AppKit
import SwiftUI

let centerDividerKey = "centerDividerKey"
let leftDividerKey = "leftDividerKey"
let rightDividerKey = "rightDividerKey"

struct QuadView4: NSViewRepresentable {
// SwiftUI struct conforms to NSViewRepresentable and bridges NSSplitView into SwiftUI

    @Binding var centerDividerPosition: CGFloat
    @Binding var leftDividerPosition: CGFloat
    @Binding var rightDividerPosition: CGFloat

// This function is where the initial setup of the view takes place.
    func makeNSView(context: Context) -> NSSplitView {
        let splitView = configureSplitView(context: context)
        return splitView
    }

    func updateNSView(_ nsView: NSSplitView, context: Context) {
        debugPrint("updateNSView executed")
// Since the positions are already being handled, there may not be much needed here.
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private func configureSplitView(context: Context) -> NSSplitView {
        let splitView = SavingNSSplitView()
        splitView.delegate = context.coordinator
        splitView.isVertical = true
        splitView.dividerStyle = .thin
        splitView.autoresizingMask = [.width, .height]

        let leftSplitView = NSSplitView()
        leftSplitView.isVertical = false
        leftSplitView.dividerStyle = .thin
        leftSplitView.addArrangedSubview(createTextView())
        leftSplitView.addArrangedSubview(createTextView())

        let rightSplitView = NSSplitView()
        rightSplitView.isVertical = false
        rightSplitView.dividerStyle = .thin
        rightSplitView.addArrangedSubview(createTextView())
        rightSplitView.addArrangedSubview(createTextView())

        splitView.addArrangedSubview(leftSplitView)
        splitView.addArrangedSubview(rightSplitView)

        loadDividerPositions(splitView: splitView, leftSplitView: leftSplitView, rightSplitView: rightSplitView)

        context.coordinator.registerSplitView(splitView: leftSplitView, forKey: leftDividerKey)
        context.coordinator.registerSplitView(splitView: rightSplitView, forKey: rightDividerKey)

        return splitView
    }

    private func createTextView() -> NSView {
        let scrollView = NSScrollView()
        let textView = NSTextView()

        scrollView.documentView = textView
        scrollView.hasVerticalScroller = true

      // Configure your NSTextView further if needed
        return scrollView
    }

    private func loadDividerPositions(splitView: NSSplitView, leftSplitView: NSSplitView, rightSplitView: NSSplitView) {
        let centerPosition = CGFloat(UserDefaults.standard.float(forKey: centerDividerKey))
        let leftPosition = CGFloat(UserDefaults.standard.float(forKey: leftDividerKey))
        let rightPosition = CGFloat(UserDefaults.standard.float(forKey: rightDividerKey))

        splitView.setPosition(centerPosition, ofDividerAt: 0)
        leftSplitView.setPosition(leftPosition, ofDividerAt: 0)
        rightSplitView.setPosition(rightPosition, ofDividerAt: 0)

      // Directly update the binding variables
        centerDividerPosition = centerPosition
        leftDividerPosition = leftPosition
        rightDividerPosition = rightPosition
    }

    class Coordinator: NSObject, NSSplitViewDelegate {
        var parent: QuadView4

        init(_ parent: QuadView4) {
            self.parent = parent
        }

        func registerSplitView(splitView: NSSplitView, forKey key: String) {
            NotificationCenter.default.addObserver(self,
               selector: #selector(horizontalSplitViewDidResize(_:)),
               name: NSView.frameDidChangeNotification,
               object: splitView)
        }
        
    @objc func horizontalSplitViewDidResize(_ notification: Notification) {
        guard let splitView = notification.object as? NSSplitView else { return }

        let newPosition: CGFloat
        if let leftSplitView = splitView.arrangedSubviews.first as? NSSplitView {
            newPosition = leftSplitView.frame.width
      // This is the left split view
            DispatchQueue.main.async {
                self.parent.leftDividerPosition = newPosition
                UserDefaults.standard.set(Float(newPosition), forKey: leftDividerKey)
            }
        } else if let rightSplitView = splitView.arrangedSubviews.last as? NSSplitView {
            newPosition = rightSplitView.frame.width
      // This is the right split view
            DispatchQueue.main.async {
                self.parent.rightDividerPosition = newPosition
                UserDefaults.standard.set(Float(newPosition), forKey: rightDividerKey)
            }
        }
    }
 }
        
    class SavingNSSplitView: NSSplitView {
        override func mouseUp(with event: NSEvent) {
            super.mouseUp(with: event)
            saveDividerPositions()
        }
        
        private func saveDividerPositions() {
// Save the center divider position
            if self.subviews.count > 1 { // Ensure there are at least two subviews
                let centerDividerPosition = self.subviews[0].frame.width
                UserDefaults.standard.set(Float(centerDividerPosition), forKey: centerDividerKey)
            }
// Assuming the first and second subviews are split views for the left and right areas
            if let leftSplitView = self.arrangedSubviews.first as? NSSplitView,
                    leftSplitView.subviews.count > 1, // Ensure there are at least two subviews
               let rightSplitView = self.arrangedSubviews.last as? NSSplitView,
                    rightSplitView.subviews.count > 1 {
                
                let leftDividerPosition = leftSplitView.subviews[0].frame.width
                let rightDividerPosition = rightSplitView.subviews[0].frame.width
                
                UserDefaults.standard.set(Float(leftDividerPosition), forKey: leftDividerKey)
                UserDefaults.standard.set(Float(rightDividerPosition), forKey: rightDividerKey)
            }
        }
        
// Helper method to safely get the divider position
        private func dividerPosition(for index: Int) -> CGFloat {
            guard index < self.dividersCount else { return 0 }
            return self.subviews[index].frame.size.width
        }
        
// Computed property to get the number of dividers
        private var dividersCount: Int {
            return self.subviews.count - 1
        }
    }
}
    


//#Preview {
//    QuadView4()
//}
