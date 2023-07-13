//
//  BookCardView.swift
//  APINewYorkTimes
//
//  Created by Vladimir Lukyanenko on 13.07.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct BookCardView: View {
    let book: Book
    @Namespace private var animation
    @Binding var showDetailView: Bool
    @Binding var selectedBook: Book?
    @Binding var animationCurrentBook: Bool

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let rect = geometry.frame(in: .named("SCROLLVIEW"))

            HStack(spacing: -25) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(book.title)
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text("By \(book.author)")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Spacer(minLength: 10)

                    HStack(spacing: 4) {
                        Text("\(book.description)")
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
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)
                }
                .zIndex(1)
                .offset(x: animationCurrentBook && selectedBook?.id == book.id ? -20 : 0)

                ZStack {
                    if !(showDetailView && selectedBook?.id == book.id) {
                        if let url = URL(string: book.bookImage) {
                            WebImage(url: url)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width / 2, height: size.height)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .matchedGeometryEffect(id: book.id, in: animation)

                                .shadow(color: .black.opacity(0.08), radius: 5, x: 5, y: 5)
                                .shadow(color: .black.opacity(0.08), radius: 5, x: -5, y: -5)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: size.width)
            .rotation3DEffect(.init(degrees: convertOffsetToRotation(rect)), axis: (x: 1, y: 0, z: 0), anchor: .bottom, anchorZ: 1, perspective: 0.8)
        }
        .frame(height: 220)
    }

    func convertOffsetToRotation(_ rect: CGRect) -> CGFloat {
        let cardHeight = rect.height + 20
        let minY = rect.minY - 20
        let progress = minY < 0 ? (minY / cardHeight) : 0
        let constrainedProgress = min(-progress, 1.0)
        return constrainedProgress * 90
    }
}

