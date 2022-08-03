//
//  StoryStore+FavoritesHandler.swift
//  Hacker News
//
//  Created by Anna Izzo on 03/08/22.
//

import Foundation

extension StoryStore {
    
    var fileURL: URL {
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return docDir.appendingPathComponent("FavoritesStoriesList.json")
    }

    func loadFavorites() throws {
        let data = try Data(contentsOf: self.fileURL)
        let decodedList = try JSONDecoder().decode(Array<Int>.self, from: data)
        self.favoritesStoriesList = decodedList
    }
    
    func saveFavorites() throws {
        let encodedFavorites = try JSONEncoder().encode(self.favoritesStoriesList)
        try encodedFavorites.write(to: self.fileURL, options: [.atomic])
    }
    
    func save() {
        do {
            try saveFavorites()
        } catch {
            print(error.localizedDescription)
        }
    }

    func decodeSavedFavorites() async {
        self.favoritesStories = []
        for storyID in favoritesStoriesList {
            await decodeAndAddItem(itemID: storyID, storyListType: .favorites)
        }
    }
    
    func addOrRemoveFavorite(item: Item){
        if itemIsFavorite(item: item) {
            self.favoritesStories = self.favoritesStories.filter({$0.id != item.id})
            self.favoritesStoriesList = self.favoritesStoriesList.filter({$0 != item.id})
        } else {
            self.favoritesStories.append(item)
            self.favoritesStoriesList.append(item.id)
        }
        save()
    }
    
    func itemIsFavorite(item: Item) -> Bool {
        if self.favoritesStoriesList.contains(item.id) {
            return true
        } else {
            return false
        }
    }
}
