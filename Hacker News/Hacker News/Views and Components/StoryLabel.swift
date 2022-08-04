//
//  StoryLabel.swift
//  Hacker News
//
//  Created by Anna Izzo on 04/08/22.
//

import SwiftUI

struct StoryLabel : View {
    @State var item: Item
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            HStack {
                Text(item.type?.capitalized ?? "")
                    .font(.footnote)
                    .fontWeight(.light)
                
                Spacer()
                Text(item.formattedDate)
                    .font(.footnote)
                    .fontWeight(.regular)
            }
            .padding(.bottom, 10)
            
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
                    
                    Text("By \(item.by ?? "")")
                        .font(.subheadline)
                }
            }
            
        }
    }
}

struct StoryLabel_Previews: PreviewProvider {
    static var previews: some View {
        StoryLabel(item: Item.storyExample)
    }
}
