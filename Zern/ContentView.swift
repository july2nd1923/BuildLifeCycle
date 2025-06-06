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
            VStack(spacing: 40) {
                // 상단 로고 및 앱 소개
                VStack(spacing: 8) {
                    Image(systemName: "leaf.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.green)

                    Text("Building Life Cycle Predictor") // 앱 타이틀
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Visually predict building lifespan and carbon neutrality") // 앱 설명
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .multilineTextAlignment(.center)
                .padding(.top, 40)

                // 기능 버튼 세 개 (입력, 탄소중립, 도시 리노베이션)
                VStack(spacing: 20) {
                    NavigationLink(destination: BuildingInputView()) {
                        HomeButtonView(title: "🏗 Enter Building Info", color: .blue)
                    }

                    NavigationLink(destination: CarbonNeutralInputView(
                        preLifeSpan: 50,
                        preEmbeddedCarbon: 0.0
                    )) {
                        HomeButtonView(title: "🌿 Carbon Neutral Simulator", color: .green)
                    }

                    NavigationLink(destination: CityRenovationView()) {
                        HomeButtonView(title: "🏙 View City Renovation", color: .purple)
                    }
                }

                Spacer()

                // 하단 저작권 표시
                Text("© 2025 Zern")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
}

// 홈 화면에서 공통적으로 사용되는 버튼 뷰
struct HomeButtonView: View {
    var title: String     // 버튼에 표시할 텍스트
    var color: Color      // 배경 색상

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
