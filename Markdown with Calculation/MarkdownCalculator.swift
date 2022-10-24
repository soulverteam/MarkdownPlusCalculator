//
//  MarkdownToHTML.swift
//  Markdown with Calculation
//
//  Created by Zac Cohan on 21/10/2022.
//

import Foundation
import SoulverCore
import RegexBuilder

class MarkdownCalculator {
    
    class func evaluateExpressionsIn(markdown: String) -> String {
                
        let captureBraceContents = Regex {
            "{"
            Capture({
                OneOrMore(.any, .reluctant)
            })
            "}"
        }
    
        let calculator = Calculator(customization: .standard)
        
        return markdown.replacing(captureBraceContents, with: { match in
            
            let evaluated = calculator.calculate(String(match.output.1))
            
            return evaluated.stringValue
            
        })
        
    }
    
}


