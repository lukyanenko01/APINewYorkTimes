//
//  LoadingView.swift
//  APINewYorkTimes
//
//  Created by Vladimir Lukyanenko on 13.07.2023.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            .scaleEffect(2)
    }
}

