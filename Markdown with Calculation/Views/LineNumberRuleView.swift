//
//  LineNumberRuleView.swift
//  Markdown with Calculation
//
//  Created by Zac Cohan on 21/10/2022.
//

import Cocoa

// https://developer.apple.com/forums/thread/683064
// implementation by krzyzanowskim

class LineNumberRulerView: NSRulerView {
    private weak var textView: NSTextView?

    init(textView: NSTextView) {
        self.textView = textView
        super.init(scrollView: textView.enclosingScrollView!, orientation: .verticalRuler)
        clientView = textView.enclosingScrollView!.documentView

        NotificationCenter.default.addObserver(forName: NSView.frameDidChangeNotification, object: textView, queue: nil) { [weak self] _ in
            self?.needsDisplay = true
        }

        NotificationCenter.default.addObserver(forName: NSText.didChangeNotification, object: textView, queue: nil) { [weak self] _ in
            self?.needsDisplay = true
        }
        
        self.ruleThickness = 35.0

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func drawHashMarksAndLabels(in rect: NSRect) {
                
        guard let context = NSGraphicsContext.current?.cgContext,
              let textView = textView,
              let textLayoutManager = textView.textLayoutManager
        else {
            return
        }

        var relativePoint = self.convert(NSZeroPoint, from: textView)
        
        relativePoint.y += textView.textContainerInset.height

        context.saveGState()
        context.textMatrix = CGAffineTransform(scaleX: 1, y: isFlipped ? -1 : 1)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedSystemFont(ofSize: self.textView!.font!.pointSize, weight: .light),
            .foregroundColor: NSColor.tertiaryLabelColor,
        ]

        var lineNum = 1
        textLayoutManager.enumerateTextLayoutFragments(from: nil, options: [.ensuresLayout]) { fragment in
            let fragmentFrame = fragment.layoutFragmentFrame

            for (subLineIdx, textLineFragment) in fragment.textLineFragments.enumerated() where subLineIdx == 0 {
                let locationForFirstCharacter = textLineFragment.locationForCharacter(at: 0)
                let ctline = CTLineCreateWithAttributedString(CFAttributedStringCreate(nil, "\(lineNum)" as CFString, attributes as CFDictionary))
                
                let startPoint = lineNum > 9 ? 8.0 : 14.0
                
                context.textPosition = fragmentFrame.origin.applying(.init(translationX: startPoint, y: locationForFirstCharacter.y + relativePoint.y))
                CTLineDraw(ctline, context)
            }

            lineNum += 1
            return true
        }
        

        context.restoreGState()
    }
    
}
