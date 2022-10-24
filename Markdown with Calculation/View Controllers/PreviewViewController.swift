
import Cocoa
import WebKit
import Ink

class PreviewViewController: NSViewController {

    @IBOutlet var previewView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.view.wantsLayer = true
        self.view.layer!.backgroundColor = NSColor.white.cgColor
    }
    
    func updatePreview(markdown: String) {
        let html = MarkdownParser().html(from: markdown)
        previewView.loadHTMLString(self.wrapForDisplay(markdownHtml: html), baseURL: nil)
    }
    
    func wrapForDisplay(markdownHtml: String) -> String {
                
            return """
            <html>
            <head>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style>
                \(self.css)
                .markdown-body {
                    box-sizing: border-box;
                    min-width: 200px;
                    max-width: 980px;
                    margin: 0 auto;
                    padding: 45px;
                }

                @media (max-width: 767px) {
                    .markdown-body {
                        padding: 15px;
                    }
                }
            </style>
            </head>
            <body>
            <article class="markdown-body">
                \(markdownHtml)
            </article>
            </body>
            </html>
            """
            
    }
    
    var css: String {
        
        let cssURL = Bundle.main.url(forResource: "github-markdown", withExtension: "css")!
        return try! String(contentsOf: cssURL, encoding: .utf8)

    }
    
 
    
}
