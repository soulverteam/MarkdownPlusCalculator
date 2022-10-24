//
//  DocumentWindowController.swift
//  Markdown with Calculation
//
//  Created by Zac Cohan on 21/10/2022.
//

import Cocoa

class DocumentWindowController: NSWindowController, TextViewControllerDelegate {
    
    // MARK: -  Delegate Methods
    
    func textWasEdited(viewController: TextViewController) {
       
        self.myDocument.modify(content: viewController.textView.string)
        self.previewViewController.updatePreview(markdown: self.myDocument.processedMarkdown)

    }

    // MARK: - Getters
    
    var textViewController: TextViewController {
        return self.splitViewController.children.first! as! TextViewController
    }
    
    var previewViewController: PreviewViewController {
        return self.splitViewController.children.last! as! PreviewViewController
    }
    
    var splitViewController: NSSplitViewController {
        return self.window!.contentViewController as! NSSplitViewController
    }
    
    var myDocument: Document {
        return self.document as! Document
    }

    // MARK: -  NSWindowController
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.textViewController.delegate = self
    
    }
    
    // MARK: -  Document
    
    func documentWasSet() {
        if self.isWindowLoaded {
            self.textViewController.setEditorContents(text: self.myDocument.content)
            self.previewViewController.updatePreview(markdown: self.myDocument.processedMarkdown)
        }
    }
    

    

}
