//
//  Story.swift
//  Hacker News
//
//  Created by Anna Izzo on 03/08/22.
//

import Foundation

struct Story : Codable, Identifiable, Equatable {
    let by : String?
    let descendants : Int?
    let id : Int
    let kids : [Int]?
    let score : Int?
    let time : Int?
    let title : String?
    let type : String?
    let url : String?
    
    var formattedDate: String {
        if let time = time {
            let date = Date(timeIntervalSince1970: TimeInterval(time))
            let formattedDate = date.formatted(date: .abbreviated, time: .shortened)
            return formattedDate
        } else {
            return ""
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
    
    // An item example for previews
    static let storyExample = Story(
        by: "iamflimflam1",
        descendants: 73,
        id: 32129478,
        kids: [32130999, 32129798, 32130926, 32129758, 32131224, 32130112, 32130509, 32130506, 32130129, 32130935, 32130561, 32130437, 32130340, 32130131, 32130035, 32130785, 32129727],
        score: 122,
        time: 1658081948,
        title: "Picking up free lithium cells off the street and making them safe for use",
        type: "story",
        url: "https://www.atomic14.com/2022/07/16/free-lithium-cells.html")
}



///* ------- STORY PROPERTIES LEGEND
// id           The item's unique id.
// type         The type of item. One of "job", "story" in our lists
// by           The username of the item's author.
// time         Creation date of the item, in Unix Time.
// text         The comment, story or poll text. HTML.
// kids         The ids of the item's comments, in ranked display order.
// url          The URL of the story.
// score        The story's score, or the votes for a pollopt.
// title        The title of the story, poll or job. HTML.
// descendants  In the case of stories or polls, the total comment count.
// */
