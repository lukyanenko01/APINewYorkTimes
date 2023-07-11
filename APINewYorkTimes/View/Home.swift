//
//  Home.swift
//  APINewYorkTimes
//
//  Created by Vladimir Lukyanenko on 10.07.2023.
//

import SwiftUI

struct Home: View {
    
    @State private var activeTag: String = "Biography"
    /*
     Щоб індикатор Tab працював плавно,
     нам потрібно додати відповідну геометрію
     ефект. Щоб додати відповідний
     геометричний ефект, нам потрібна анімація
     простір імен.
     */
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Browse")
                    .font(.largeTitle.bold())
                
                Text("Recommended")
                    .fontWeight(.semibold)
                    .padding(.leading, 15)
                    .foregroundColor(.gray)
                    .offset(y: 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            
            TagsView()
            
            GeometryReader {
                let size = $0.size
                
                ScrollView(.vertical, showsIndicators: false) {
                    // Books Card View
                    VStack(spacing: 35) {
                        ForEach(sampleBooks) {
                            BookCardView($0)
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 20)
                    .padding(.bottom, bottomPadding(size))
                }
                /// Since we need offset from here and not from global View
                .coordinateSpace(name: "SCROLLVIEW")
            }
            .padding(.top, 15)
        }
    }
    
    func bottomPadding(_ size: CGSize = .zero) -> CGFloat{
        let cardHeight: CGFloat = 220
        let scrollViewHeight: CGFloat = size.height
        
        return scrollViewHeight - cardHeight - 40
    }
    
    /// Book Card View
    @ViewBuilder
    func BookCardView(_ book: Book) -> some View {
        GeometryReader {
            let size = $0.size
            let rect = $0.frame(in: .named("SCROLLVIEW"))
            
            HStack(spacing: -25) {
                /// Book detail Card
                /// Placing this card above the cover image
                VStack(alignment: .leading, spacing: 6) {
                    Text(book.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("By \(book.author)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    /// Reaiting View
                    RatingView(rating: book.rating)
                        .padding(.top, 10)
                    
                    Spacer(minLength: 10)
                    
                    HStack(spacing: 4) {
                        Text("\(book.bookViews)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                        
                        Text("Views")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer(minLength: 0)
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                    }
                }
                .padding(20)
                .frame(width: size.width / 2, height: size.height * 0.8)
                .background {
                    RoundedRectangle(cornerRadius: 1, style: .continuous)
                        .fill(.white)
                    /// Applying Shadow
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)
                }
                .zIndex(1)
                .overlay {
                    Text("\(rect.minY)")
                }
                
                /// Book Cover Image
                ZStack {
                    Image(book.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width / 2, height: size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    /// Applying Shadow
                        .shadow(color: .black.opacity(0.08), radius: 5, x: 5, y: 5)
                        .shadow(color: .black.opacity(0.08), radius: 5, x: -5, y: -5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: size.width)
            .rotation3DEffect(.init(degrees: convertOffsetToRotation(rect)), axis: (x: 1, y: 0, z: 0), anchor: .bottom, anchorZ: 1, perspective: 0.8)
        }
        .frame(height: 220)
    }
    
    /// Converting MinY to Rotation
    func convertOffsetToRotation(_ rect: CGRect) -> CGFloat {
        let cardHeight = rect.height + 20
        let minY = rect.minY - 20
        let progress = minY < 0 ? (minY / cardHeight) : 0
        let constrainedProgress = min(-progress, 1.0)
        return constrainedProgress * 90
    }
    
    
    /// Tags Vieew
    @ViewBuilder
    func TagsView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background {
                            if activeTag == tag {
                                Capsule()
                                    .fill(Color.blue)
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            } else {
                                Capsule()
                                    .fill(.gray.opacity(0.2))
                            }
                        }
                        .foregroundColor(activeTag == tag ? .white : .gray)
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
                                activeTag = tag
                            }
                        }
                }
            }
            .padding(.horizontal, 15)
        }
    }
}

/// Sample Tags
var tags: [String] = ["History", "Classical", "Biography", "Cartoon", "Adventure", "Fairy tales", "Fantasy"]

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/// Custom Rating View
struct RatingView: View {
    var rating: Int
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundColor(index <= rating ? . yellow : .gray.opacity(0.5))
            }
            
            Text("(\(rating))")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.yellow)
                .padding(.leading, 5)
        }
    }
}
