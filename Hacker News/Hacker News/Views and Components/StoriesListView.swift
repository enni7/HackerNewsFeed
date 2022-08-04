//
//  StoriesListView.swift
//  Hacker News
//
//  Created by Anna Izzo on 03/08/22.
//

import SwiftUI

struct StoriesListView: View {
    @StateObject var storyStore = StoryStore.shared
    @Binding var storyListType: StoryListType
    
    //List of Stories to display
    var storiesList: [Item] {
        switch storyListType {
        case .favorites:
            return storyStore.favoritesStories
        default:
            return storyStore.stories
        }
    }
    
    var body: some View {
        List{
            ForEach(storiesList){ story in
                ItemView(item: story)
                    .buttonStyle(.plain)
            }
        }
        .listStyle(.plain)
        .refreshable {
            if storyListType == .favorites {
                Task{ await storyStore.decodeSavedFavorites() }
            } else {
                storyStore.isRefreshing.toggle()
                Task{
                    await storyStore.loadStoriesIDList(listType: storyListType)
                    await storyStore.decodeStoriesArray(for: storyListType)
                }
            }
        }
    }
}

struct StoriesListView_Previews: PreviewProvider {
    static var previews: some View {
        StoriesListView(storyListType: .constant(.top))
    }
}
