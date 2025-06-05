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

    // 추가: 보수 주기 및 1회 보수 시 생애 연장
    var repairCycle: Int = 10
    var lifeExtensionPerRepair: Int = 3

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

        // 보수 반영 생애주기 계산
        let totalRepairs = repairCycle > 0 ? result.finalLife / repairCycle : 0
        let extendedLife = result.finalLife + totalRepairs * lifeExtensionPerRepair

        VStack(spacing: 20) {
            Text("예상 건물 수명: \(result.finalLife)년")
                .font(.title)
                .bold()

            Text("추천 리모델링 시점: \(result.finalLife / 2)년 후")
                .foregroundColor(.gray)

            Text("예상 초기 탄소 배출량: \(carbonEmission) kg CO₂")
                .foregroundColor(.green)

            Text("🔧 보수 반영 시 생애주기: \(extendedLife)년")
                .foregroundColor(.blue)
                .bold()

            BarChartView(stages: [
                ("기초 수명", result.base),
                ("환경 반영", result.afterEnv),
                ("점검 반영", result.afterRepair),
                ("최종 수명", result.finalLife)
            ])

            NavigationLink(
                destination: CarbonNeutralInputView(
                    preLifeSpan: result.finalLife,
                    preEmbeddedCarbon: Double(carbonEmission)
                )
            ) {
                Text("이 값을 기반으로 탄소중립 예측하기")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("예측 결과")
    }
}
