//
//  ContentView.swift
//  BuildLifeCycle
//
//  Created by Juliana Lee on 6/3/25.

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                VStack(spacing: 8) {
                    Image(systemName: "leaf.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.green)

                    Text("건물 생애 주기 예측기")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("건물 수명과 탄소중립을 시각적으로 예측해보세요")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .multilineTextAlignment(.center)
                .padding(.top, 40)

                VStack(spacing: 20) {
                    NavigationLink(destination: BuildingInputView()) {
                        HomeButtonView(title: "🏗 건물 정보 입력하기", color: .blue)
                    }

                    NavigationLink(destination: CarbonNeutralInputView(
                        preLifeSpan: 50,
                        preEmbeddedCarbon: 0.0
                    )) {
                        HomeButtonView(title: "🌿 탄소중립 시뮬레이터", color: .green)
                    }

                    NavigationLink(destination: CityRenovationView()) {
                        HomeButtonView(title: "🏙 도시 리노베이션 보기", color: .purple)
                    }
                }

                Spacer()

                Text("© 2025 Zern")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
}

struct HomeButtonView: View {
    var title: String
    var color: Color

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .cornerRadius(12)
            .shadow(color: color.opacity(0.4), radius: 4, x: 0, y: 2)
    }
}
