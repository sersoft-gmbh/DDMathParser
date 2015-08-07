//
//  HexNumberExtractor.swift
//  DDMathParser
//
//  Created by Dave DeLong on 8/6/15.
//
//

import Foundation

internal struct HexNumberExtractor: TokenExtractor {
    
    func matchesPreconditions(buffer: TokenCharacterBuffer) -> Bool {
        return buffer.peekNext() == "0" && buffer.peekNext(1, lowercase: true) == "x"
    }
    
    func extract(buffer: TokenCharacterBuffer) -> TokenGenerator.Element {
        let start = buffer.currentIndex
        
        if buffer.peekNext() == "0" && buffer.peekNext(1, lowercase: true) == "x" {
            buffer.consume(2)
            
            let indexBeforeHexNumbers = buffer.currentIndex
            while buffer.peekNext()?.isHexDigit == true {
                buffer.consume()
            }
            
            if buffer.currentIndex == indexBeforeHexNumbers {
                // there wasn't anything after 0[xX]
                buffer.resetTo(start)
            }
        }
        
        let range = start ..< buffer.currentIndex
        let result: TokenGenerator.Element
        
        if start.distanceTo(buffer.currentIndex) > 0 {
            let raw = buffer[range]
            result = .Value(Token(kind: .HexNumber, string: raw, sourceRange: range))
        } else {
            let error = TokenizerError(kind: .CannotParseHexNumber, sourceRange: range)
            result = .Error(error)
        }
        
        return result
    }

}
