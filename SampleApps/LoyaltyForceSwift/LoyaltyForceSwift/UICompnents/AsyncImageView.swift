//
//  AsyncImageView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 11/25/22.
//

import SwiftUI

struct AsyncImageView: View {

    let imageUrl: String?
    
    var body: some View {
        
        if let imageUrl = imageUrl {
            AsyncImage(url: URL(string: imageUrl)) { phase in
                switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:

                        //Call the AsynchImage 2nd time - when there is a failure. (I think you can also check NSURLErrorCancelled = -999)
                        AsyncImage(url: URL(string: imageUrl)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                            } else{
                                Image("img-placeholder")
                                    .resizable()
                                    .scaledToFill()
                            }
                        }
                    default:
                        ProgressView()
                }
            }
        } else {
            Image("img-placeholder")
                .resizable()
                .scaledToFill()
        }
    }
}

struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageView(imageUrl: "https://picsum.photos/800")
    }
}
