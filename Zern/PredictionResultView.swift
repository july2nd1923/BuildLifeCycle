//
//  PredictionResultView.swift
//  BuildLifeCycle
//
//  Created by Juliana Lee on 6/3/25.
//

import SwiftUI

struct PredictionResultView: View {
    // 전달받은 입력값
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

    // 선택적 파라미터: 보수 주기 및 1회 보수 시 연장 수명
    var repairCycle: Int = 10
    var lifeExtensionPerRepair: Int = 3

    var body: some View {
        // 생애주기 예측 실행
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

        // 초기 내재 탄소 배출량 계산
        let carbonEmission = LifeCyclePredictor.calculateCarbonEmission(
            materialRatios: materialRatios
        )

        // 보수 주기를 고려한 연장 생애주기 계산
        let totalRepairs = repairCycle > 0 ? result.finalLife / repairCycle : 0
        let extendedLife = result.finalLife + totalRepairs * lifeExtensionPerRepair

        VStack(spacing: 20) {
            // 예측 수명 결과 출력
            Text("Predicted Building Lifespan: \(result.finalLife) years")
                .font(.title)
                .bold()

            // 추천 리모델링 시점 (수명의 절반 기준)
            Text("Recommended Remodeling: after \(result.finalLife / 2) years")
                .foregroundColor(.gray)

            // 내재 탄소 배출량 출력
            Text("Estimated Initial Carbon Emission: \(carbonEmission) kg CO₂")
                .foregroundColor(.green)

            // 보수 반영 시 수명
            Text("🔧 Extended Lifespan with Repairs: \(extendedLife) years")
                .foregroundColor(.blue)
                .bold()

            // 수명 변화 시각화 그래프
            BarChartView(stages: [
                ("Base", result.base),
                ("After Env", result.afterEnv),
                ("After Inspection", result.afterRepair),
                ("Final", result.finalLife)
            ])

            // 탄소중립 시뮬레이터로 이동 버튼
            NavigationLink(
                destination: CarbonNeutralInputView(
                    preLifeSpan: result.finalLife,
                    preEmbeddedCarbon: Double(carbonEmission)
                )
            ) {
                Text("Predict Carbon Neutrality Based on These Values")
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
        .navigationTitle("Prediction Result")
    }
}
