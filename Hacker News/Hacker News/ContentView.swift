//
//  ContentView.swift
//  Hacker News
//
//  Created by Anna Izzo on 01/08/22.
//

import SwiftUI
import WebKit

struct ContentView: View {
    
    @StateObject var storyStore = StoryStore.shared
    @State var storyListType: StoryListType = .newest
    
    //---Custom segmented control appearance
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(.accentColor.opacity(0.9))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.white)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.primary)], for: .normal)
    }
    
    var body: some View {
        NavigationView{
            VStack(spacing: 0){
                
                VStack(spacing: 0) {
                    Text("Hacker News")
                        .font(.largeTitle)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.bottom)
                    
                    Picker(selection: $storyListType) {
                        ForEach(StoryListType.allCases, id: \.self) { listType in
                            Text(listType.rawValue)
                        }
                    } label: { EmptyView()}
                        .pickerStyle(.segmented)
                        .background{
                            Color(UIColor.systemBackground).opacity(0.8)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                }
                .background{
                    Color.accentColor.opacity(0.9)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .ignoresSafeArea()
                }
                
                StoriesListView(storyListType: $storyListType)
            }
            .navigationBarHidden(true)
        }
        
        .onAppear{
            loadStories()
            loadFavorites()
        }
        
        .onChange(of: storyListType) { listType in
            refreshStories(listType: listType)
        }
    }
    
    func refreshStories(listType: StoryListType){
        if listType != .favorites {
            storyStore.isRefreshing.toggle()
            loadStories()
        }
    }
    
    func loadStories(){
        Task{
            await storyStore.loadStoriesIDList(listType: storyListType)
            await storyStore.decodeStoriesArray(for: storyListType)
        }
    }
    
    func loadFavorites(){
        do {
            try storyStore.loadFavorites()
        } catch {
            print(error.localizedDescription)
        }
        Task{
            await storyStore.decodeSavedFavorites()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.light)
    }
}
