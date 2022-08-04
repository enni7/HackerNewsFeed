//
//  ItemView.swift
//  Hacker News
//
//  Created by Anna Izzo on 03/08/22.
//

import SwiftUI

struct ItemView: View {
    @StateObject var storyStore = StoryStore.shared
    
    @State var item: Item
    
    @State var navigationLinkTo: NavigationTypes = .storyWebPage
    @State var toggleNavigation: Bool = false
    
    enum NavigationTypes {
        case storyWebPage, comments
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            
            Group{
                NavigationLink(isActive: $toggleNavigation) {
                    if self.navigationLinkTo == .comments {
                        CommentsListView(item: item)
                    } else {
                        if let itemUrl = item.url {
                            WebView(urlString: itemUrl)
                                .navigationBarTitleDisplayMode(.inline)
                                .ignoresSafeArea(.all, edges: .bottom)
                        } else {
                            Text("Sorry, couldn't found the story web page.")
                        }
                    }
                } label: { EmptyView() }
                    .opacity(0)
                
                StoryLabel(item: item)
            }
            .onTapGesture {
                navigationLinkTo = .storyWebPage
                toggleNavigation.toggle()
            }
            
            HStack{
                Label {
                    Text("\(item.score ?? 0)")
                        .font(.callout)
                } icon: {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .foregroundColor(.accentColor)
                }
                
                Spacer()
                Button {
                    navigationLinkTo = .comments
                    toggleNavigation.toggle()
                } label: {
                    Label {
                        Text("\(item.descendants ?? 0)")
                            .font(.callout)
                    } icon: {
                        Image(systemName: "message")
                            .foregroundColor(.accentColor)
                    }
                    .padding(8)
                }
                .fixedSize()
                .buttonStyle(.plain)
                
                Spacer()
                Button {
                    storyStore.addOrRemoveFavorite(item: item)
                } label: {
                    Image(systemName: storyStore.itemIsFavorite(item: item) ? "heart.fill" : "heart")
                        .foregroundColor(.accentColor)
                }
                .padding([.vertical, .leading], 8)
            }
            .font(.headline)
        }
    }
}


struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(item: Item.storyExample)
    }
}
