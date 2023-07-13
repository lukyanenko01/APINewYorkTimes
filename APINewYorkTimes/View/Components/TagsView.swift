//
//  TagsView.swift
//  APINewYorkTimes
//
//  Created by Vladimir Lukyanenko on 13.07.2023.
//

import SwiftUI

struct TagsView: View {
    @ObservedObject var viewModel: HomeViewModel
    var animation: Namespace.ID

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(BookCategory.allCases, id: \.self) { tag in
                    Text(tag.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background {
                            if viewModel.activeTag == tag {
                                Capsule()
                                    .fill(Color.blue)
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            } else {
                                Capsule()
                                    .fill(.gray.opacity(0.2))
                            }
                        }
                        .foregroundColor(viewModel.activeTag == tag ? .white : .gray)
                        .onTapGesture {
                            if !viewModel.isLoading {
                                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
                                    viewModel.handleTagTap(tag)
                                }
                            }
                        }
                }
            }
            .padding(.horizontal, 15)
        }
    }
}

