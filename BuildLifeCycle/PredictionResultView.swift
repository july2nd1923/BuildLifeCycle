//
//  PredictionResultView.swift
//  BuildLifeCycle
//
//  Created by Juliana Lee on 6/3/25.
//
import SwiftUI

struct PredictionResultView: View {
    var yearBuilt: String
    var materialRatios: [String: Double]
    var usage: String
    var floors: Int
    var materialLives: [String: Int]
    var environment: String
    var recentlyRepaired: Bool
    var hasCracks: Bool
    var hasLeakage: Bool
    var hasCorrosion: Bool

    var body: some View {
        let result = LifeCyclePredictor.predict(
            yearBuilt: yearBuilt,
            materialRatios: materialRatios,
            usage: usage,
            floors: floors,
            materialLives: materialLives,
            environment: environment,
            recentlyRepaired: recentlyRepaired,
            hasCracks: hasCracks,
            hasLeakage: hasLeakage,
            hasCorrosion: hasCorrosion
        )

        let carbonEmission = LifeCyclePredictor.calculateCarbonEmission(
            materialRatios: materialRatios
        )

        VStack(spacing: 20) {
            Text("예상 건물 수명: \(result.finalLife)년")
                .font(.title)
                .bold()

            Text("추천 리모델링 시점: \(result.finalLife / 2)년 후")
                .foregroundColor(.gray)

            Text("예상 초기 탄소 배출량: \(carbonEmission) kg CO₂")
                .foregroundColor(.green)

            BarChartView(stages: [
                ("기초 수명", result.base),
                ("환경 반영", result.afterEnv),
                ("점검 반영", result.afterRepair),
                ("최종 수명", result.finalLife)
            ])

            Spacer()
        }
        .padding()
        .navigationTitle("예측 결과")
    }
}
