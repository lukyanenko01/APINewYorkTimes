//
//  HomeView.swift
//  APINewYorkTimes
//
//  Created by Vladimir Lukyanenko on 10.07.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    @Namespace private var animation
    @State private var showDetailView: Bool = false
    @State private var selectedBook: Book?
    @State private var animationCurrentBook: Bool = false

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Books API")
                    .font(.largeTitle.bold())
                
                Text("Best Sellers Lists")
                    .fontWeight(.semibold)
                    .padding(.leading, 15)
                    .foregroundColor(.gray)
                    .offset(y: 2)
                
                Spacer(minLength: 10)
                
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            
            TagsView(viewModel: viewModel, animation: animation)
            
            GeometryReader {
                let size = $0.size
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 35) {
                        ForEach(viewModel.books) { book in
                            BookCardView(book: book, showDetailView: $showDetailView, selectedBook: $selectedBook, animationCurrentBook: $animationCurrentBook)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        animationCurrentBook = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                            showDetailView = true
                                            selectedBook = book
                                            
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 20)
                    .padding(.bottom, bottomPadding(size))
                }
                .coordinateSpace(name: "SCROLLVIEW")
            }
            .padding(.top, 15)
        }
        .overlay {
            if let selectedBook, showDetailView {
                DetailView(show: $showDetailView,animation: animation, book: selectedBook)
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: 5)))
            }
        }
        .onChange(of: showDetailView) { newValue in
            if !newValue {
                withAnimation(.easeInOut(duration: 0.15).delay(0.4)) {
                    animationCurrentBook = false
                }
            }
        }
        .overlay {
            Group {
                if let error = viewModel.error {
                    ErrorView(error: error)
                } else if viewModel.isLoading {
                    LoadingView()
                }
            }
        }
        .onAppear {
            viewModel.fetchBooks()
        }
        
    }
    
    func bottomPadding(_ size: CGSize = .zero) -> CGFloat{
        let cardHeight: CGFloat = 220
        let scrollViewHeight: CGFloat = size.height
        
        return scrollViewHeight - cardHeight - 40
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



