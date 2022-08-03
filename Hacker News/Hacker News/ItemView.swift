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
    @State var showStory: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            
            Group{
                NavigationLink(isActive: $showStory) {
                    if let itemUrl = item.url {
                        WebView(urlString: itemUrl)
                            .navigationBarTitleDisplayMode(.inline)
                            .ignoresSafeArea(.all, edges: .bottom)
                    } else {
                        Text("Sorry, couldn't found the story web page.")
                    }
                } label: { EmptyView() }
                    .opacity(0)
                
                HStack {
                    Text(item.type?.capitalized ?? "")
                        .font(.footnote)
                        .fontWeight(.light)
                    
                    Spacer()
                    Text(item.formattedDate)
                        .font(.footnote)
                        .fontWeight(.regular)
                }
                .padding(.bottom, 4)
                
                HStack{
                    AsyncImage(url: URL(string: item.iconUrl)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .transition(.opacity)
                        }
                        else {
                            Image(systemName: "safari")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .transition(.opacity)
                        }
                    }
                    .padding(.trailing)
                    
                    VStack(alignment:.leading, spacing: 8){
                        Text(item.title ?? "")
                            .font(.headline)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.leading)
                        
                        Text("\(item.by ?? "")")
                            .font(.subheadline)
                    }
                }
            }
            .onTapGesture {
                showStory.toggle()
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
                    //
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
