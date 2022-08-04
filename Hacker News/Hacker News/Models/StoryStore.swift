//
//  StoryStore.swift
//  Hacker News
//
//  Created by Anna Izzo on 03/08/22.
//

import Foundation

public enum StoryListType: String, CaseIterable {
    case newest = "News"
    case top = "Top"
    case bestStories = "Bests"
    case favorites = "Favorites"
    
    var stringForURL : String? {
        switch self {
        case .newest:
            return "newstories"
        case .top:
            return "topstories"
        case .bestStories:
            return "beststories"
        default:
            return nil
        }
    }
}

class StoryStore: ObservableObject {
    
    static let shared: StoryStore = StoryStore()
    
    
    var storiesList = [Int]()
    @Published var stories = [Item]()
    
    var favoritesStoriesList = [Int]()
    @Published var favoritesStories = [Item]()
        
    var hasFinishedDecoding = false
    var shouldStopDecoding = false
    var isRefreshing = false {
        didSet {
            if !hasFinishedDecoding{
                shouldStopDecoding = true
            }
        }
    }
    
    private init() {

    }
            
    func loadStoriesIDList(listType: StoryListType) async {

        self.storiesList.removeAll()
        
        guard let stringTypeForUrl = listType.stringForURL,
              let url = URL(string: "https://hacker-news.firebaseio.com/v0/\(stringTypeForUrl).json") else {
            print("Invalid list url.")
            return
        }
        
        let request = URLRequest(url: url)
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let list = try JSONDecoder().decode([Int].self, from: data)
            
            DispatchQueue.main.async {
                
                //--- Loads the first 70 items (IDs) of the list
                self.storiesList.append(contentsOf: list.prefix(70))
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func decodeStoriesArray(for listType: StoryListType) async {
        hasFinishedDecoding = false
        self.stories.removeAll()
        
        for storyID in self.storiesList {
            if shouldStopDecoding {
                break
            }
            await decodeAndAddItem(itemID: storyID, storyListType: listType)
        }
        
        hasFinishedDecoding = true
        shouldStopDecoding = false
    }
    
    func decodeAndAddItem(itemID: Int, storyListType: StoryListType) async {
        //--- URL of a single item
        guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(itemID).json") else {
            print("Invalid story json url.")
            return
        }

        let urlRequest = URLRequest(url: url)
        
        //--- Decode
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let story : Item = try JSONDecoder().decode(Item.self, from: data)
            
            //--- Add the item to relative stories array
            DispatchQueue.main.asyncAndWait(execute: DispatchWorkItem(block: {
                
                if storyListType == .favorites {
                    self.favoritesStories.append(story)
                } else {
                    self.stories.append(story)
                }
            }))
        } catch {
            print("Error in decoding an item. \(error.localizedDescription)")
        }
    }
    
}
