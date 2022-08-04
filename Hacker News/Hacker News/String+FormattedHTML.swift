//
//  String+FormattedHTML.swift
//  Hacker News
//
//  Created by Anna Izzo on 04/08/22.
//

import Foundation

extension String {
    func getHtmlFormattedString() -> String {
        let data = Data(self.utf8)
        
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            let string = attributedString.string
            let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
            let newString = trimmed.replacingOccurrences(of: "â€™", with: "'", options: .literal, range: nil)
            let newString2 = newString.replacingOccurrences(of: "â€œ", with: "\"", options: .literal, range: nil)
            let newString3 = newString2.replacingOccurrences(of: "â€", with: "\"", options: .literal, range: nil)
            return newString3
        } else {
            return ""
        }
    }
}
