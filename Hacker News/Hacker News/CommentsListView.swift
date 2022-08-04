//
//  CommentsView.swift
//  Hacker News
//
//  Created by Anna Izzo on 03/08/22.
//

import SwiftUI

struct CommentsListView: View {
    var item : Item
    @State var comments = [Item]()
    @State var indentForComment = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            StoryLabel(item: item)
                .padding(.horizontal)
                .padding(.bottom)
            Divider()
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack(alignment: .leading){
                    ForEach(comments) { comment in
                        if comment.text != nil {
                            CommentView(item: comment)
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Comments")
        .onAppear{
            Task {
                await loadCurrentItemComments(for: item)
            }
        }
    }
    
    func loadCurrentItemComments(for item: Item) async {
        if let kids = item.kids {
            for kid in kids {
                guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(kid).json") else {continue}
                let urlRequest = URLRequest(url: url)
                
                do {
                    let (data, _) = try await URLSession.shared.data(for: urlRequest)
                    var comment : Item = try JSONDecoder().decode(Item.self, from: data)
                    comment.indentForComment = indentForComment
                    comment.convertHTMLCommentText()
                    self.comments.append(comment)
                    
                    if let commentKids = comment.kids {
                        if !commentKids.isEmpty {
                            indentForComment += 12
                            await loadCurrentItemComments(for: comment)
                            indentForComment -= 12
                            
                        }
                    }
                    
                } catch {
                    print("Error in decoding a comment. \(error.localizedDescription)")
                }
            }
        }
    }
}

struct CommentsListView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsListView(item: Item.storyExample)
    }
}
