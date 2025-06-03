//
//  ContentView.swift
//  BuildLifeCycle
//
//  Created by Juliana Lee on 6/3/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("건물 생애 주기 예측기")
                    .font(.largeTitle)
                    .bold()

                NavigationLink(destination: BuildingInputView()) {
                    Text("건물 정보 입력하기")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}
