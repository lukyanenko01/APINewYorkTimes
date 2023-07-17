//
//  ErrorView.swift
//  APINewYorkTimes
//
//  Created by Vladimir Lukyanenko on 13.07.2023.
//

import SwiftUI

struct ErrorView: View {
    var error: Error

    var body: some View {
        VStack {
            Text("Ошибка: \(error.localizedDescription)")
                .foregroundColor(.white)
                .padding()
        }
        .background(Color.red)
        .cornerRadius(10)
        .padding()
    }
}
