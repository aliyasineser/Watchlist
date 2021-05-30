//
//  OnboardingView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 23.03.2021.
//

import SwiftUI
import TMDBSwift

struct OnboardingView: View {
    @State var index = 0
    
    var images = ["onboarding1", "onboarding2", "onboarding3"]
    var body: some View {
        NavigationView {
            ZStack {
                PagingView(index: $index.animation(), maxIndex: images.count - 1) {
                    ForEach(self.images, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            
                    }
                }
                GeometryReader{
                    geometry in
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0){
                    
                    Spacer().frame(height: geometry.size.height/2.3)
                    
                    VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 20, content: {
                        Text("Movies & Series")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.custom("AppleGothic", size: 30))
                        Text("The world’s most popular and authoritative source for movies and series.")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.custom("AppleGothic", size: 15))
                            .multilineTextAlignment(.center)
                    })
                    Spacer().frame(height: geometry.size.height/3.65)
                    
                    NavigationLink(destination: DashboardView()) {
                        Text("Explore Collection")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.custom("AppleGothic", size: 15))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.teal)
                            .cornerRadius(30)
                    }

                    Spacer().frame(height: 20)
                }
            }
            }.edgesIgnoringSafeArea(.vertical)
        }.navigationTitle("")
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
