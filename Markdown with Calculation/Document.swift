//
//  Document.swift
//  Markdown with Calculation
//
//  Created by Zac Cohan on 21/10/2022.
//

import Cocoa

class Document: NSDocument {
    
    /// The user editable content written in markdown
    var content = ""
    
    /// The user created markdown with expressions in braces evaluated
    var processedMarkdown: String {
        return MarkdownCalculator.evaluateExpressionsIn(markdown: self.content)
    }
    
    override init() {
        super.init()
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    
    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! DocumentWindowController
        self.addWindowController(windowController)
        windowController.documentWasSet()
    }

    func modify(content: String) {
        self.content = content
        self.updateChangeCount(NSDocument.ChangeType.changeDone)
    }
        
    override func data(ofType typeName: String) throws -> Data {
        return content.data(using: .utf8) ?? Data()
    }

    override func read(from data: Data, ofType typeName: String) throws {
        
        if let fileContents = String(data: data,encoding: .utf8) {
            content = fileContents
        }
    }


}
