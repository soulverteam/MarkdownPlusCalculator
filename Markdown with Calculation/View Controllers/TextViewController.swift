
import Cocoa

protocol TextViewControllerDelegate: AnyObject {
    func textWasEdited(viewController: TextViewController)
}

class TextViewController: NSViewController, NSTextDelegate {

    @IBOutlet var textView: NSTextView!
    
    weak var delegate: TextViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.font = NSFont.systemFont(ofSize: 16.0)
        self.textView.textContainerInset = NSMakeSize(40.0, 45.0)
        
        let rulerView = LineNumberRulerView(textView: self.textView)
                
        self.textView.enclosingScrollView!.rulersVisible = true
        self.textView.enclosingScrollView!.hasVerticalRuler = true
        self.textView.enclosingScrollView!.verticalRulerView = rulerView

    }
    
    func setEditorContents(text: String) {
        self.textView.string = text
    }
    
    
    func textDidChange(_ notification: Notification) {
        self.delegate?.textWasEdited(viewController: self)
    }
    
    
}
