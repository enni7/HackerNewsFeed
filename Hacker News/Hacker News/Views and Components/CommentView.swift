//
//  CommentView.swift
//  Hacker News
//
//  Created by Anna Izzo on 04/08/22.
//

import SwiftUI

struct CommentView: View {
    @State var item: Item
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            HStack{
                Image(systemName: "message.fill")
                    .foregroundColor(.accentColor)
                    .font(.subheadline)
                Text(item.by ?? "Unknown")
                    .font(.headline)
                Spacer()
                Text(item.timeAgoDate)
                    .font(.subheadline)
                    .fontWeight(.light)
            }
            
            Text(item.text ?? "")
                .multilineTextAlignment(.leading)
        }
        .padding(.vertical, 8)
        .padding(.leading, CGFloat(item.cgFloatIndent))
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(item: Item.commentExample)
    }
}
