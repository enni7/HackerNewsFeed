//
//  Story.swift
//  Hacker News
//
//  Created by Anna Izzo on 03/08/22.
//

import Foundation
import SwiftUI

struct Item : Codable, Identifiable, Equatable {
    let by : String?
    let descendants : Int?
    let id : Int
    let kids : [Int]?
    let score : Int?
    let time : Int?
    var text : String?
    let title : String?
    let type : String?
    let url : String?
    var indentForComment: Int?
    
    var formattedDate: String {
        if let time = time {
            let date = Date(timeIntervalSince1970: TimeInterval(time))
            let formattedDate = date.formatted(date: .abbreviated, time: .shortened)
            return formattedDate
        } else {
            return ""
        }
    }
    
    var timeAgoDate: String {
        if let time = time {
            let date = Date(timeIntervalSince1970: TimeInterval(time))
            return date.timeAgo()
        } else {
            return ""
        }
    }
    
    var cgFloatIndent : CGFloat {
        guard let indentForComment = indentForComment else {return 0.0}
        if indentForComment > 60 {
            return CGFloat(60)
        } else {
            return CGFloat(indentForComment)
        }
    }
    
    // 64x64 icon URL of the story web page
    var iconUrl: String {
        if let url = url {
            let iconUrl = "https://www.google.com/s2/favicons?sz=64&domain=\(url)"
            return iconUrl
        } else {
            return ""
        }
    }
    
    // Convert the HTML formatted text in a plain string
    mutating func convertHTMLCommentText(){
        if let text = self.text {
            self.text = text.getHtmlFormattedString()
        }
    }
    
    // Story example for previews
    static let storyExample = Item(
        by: "iamflimflam1",
        descendants: 73,
        id: 32129478,
        kids: [32130999, 32129798, 32130926, 32129758, 32131224, 32130112, 32130509, 32130506, 32130129, 32130935, 32130561, 32130437, 32130340, 32130131, 32130035, 32130785, 32129727],
        score: 122,
        time: 1658081948,
        text: nil,
        title: "Picking up free lithium cells off the street and making them safe for use",
        type: "story",
        url: "https://www.atomic14.com/2022/07/16/free-lithium-cells.html")
    
    // Comment example for previews
    static let commentExample = Item(
        by: "norvig",
        descendants: nil,
        id: 2921983,
        kids: [2922097, 2922429, 2924562, 2922709, 2922573, 2922140, 2922141],
        score: 122,
        time: 1658081948,
        text: "Aw shucks, guys ... you make me blush with your compliments.<p>Tell you what, Ill make a deal: I'll keep writing if you keep reading. K?",
        title: nil,
        type: nil,
        url: nil)
}



/* ----- ITEM PROPERTIES LEGEND
 
 id           The item's unique id.
 type         The type of item. One of "job", "story" in our lists
 by           The username of the item's author.
 time         Creation date of the item, in Unix Time.
 text         The comment, story or poll text. HTML.
 kids         The ids of the item's comments, in ranked display order.
 url          The URL of the story.
 score        The story's score, or the votes for a pollopt.
 title        The title of the story, poll or job. HTML.
 descendants  In the case of stories or polls, the total comment count.
 indentForComment  For handling appearance of comment's kids.
 
 */
