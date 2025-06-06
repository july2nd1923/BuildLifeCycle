//
//  LifeCyclePredictor.swift
//  BuildLifeCycle
//
//  Created by Juliana Lee on 6/3/25.
//

import Foundation

struct LifeCyclePredictor {
    // 건물 수명을 예측하는 주요 함수
    static func predict(
        yearBuilt: String,
        materialRatios: [String: Double],
        usage: String,
        floors: Int,
        materialLives: [String: Int],
        environment: String,
        recentlyRepaired: Bool,
        hasCracks: Bool,
        hasLeakage: Bool,
        hasCorrosion: Bool
    ) -> (finalLife: Int, base: Int, afterEnv: Int, afterRepair: Int) {
        // 시공 연도와 재료 입력이 유효한지 확인
        guard let builtYear = Int(yearBuilt), !materialRatios.isEmpty else {
            return (0, 0, 0, 0)
        }

        // [1] 재료별 수명 가중 평균 계산 (기초 수명)
        var totalWeightedLife: Double = 0
        var totalRatio: Double = 0
        for (material, ratio) in materialRatios {
            if let life = materialLives[material] {
                totalWeightedLife += Double(life) * (ratio / 100.0)
                totalRatio += ratio
            }
        }
        var baseLife = Int(totalRatio > 0 ? totalWeightedLife : 0)
        let base = baseLife

        // [2] 용도 및 층수에 따른 보정
        if usage == "Public" { baseLife += 10 }
        if floors >= 10 { baseLife += 5 }

        // [3] 환경 조건에 따른 감점
        switch environment {
        case "Coastal": baseLife -= 5
        case "Seismic Zone": baseLife -= 3
        case "Hot and Humid": baseLife -= 2
        case "High-altitude Dry": baseLife -= 1
        default: break
        }
        let afterEnv = baseLife

        // [4] 점검 및 결함 상태 반영
        if recentlyRepaired { baseLife += 10 }
        if hasCracks { baseLife -= 5 }
        if hasLeakage { baseLife -= 3 }
        if hasCorrosion { baseLife -= 3 }

        let afterRepair = baseLife

        // [5] 시공 후 경과된 연도 차감
        let currentYear = Calendar.current.component(.year, from: Date())
        let age = currentYear - builtYear

        return (
            max(baseLife - age, 0),  // 최종 수명은 0 이하로 떨어지지 않게 보정
            base,
            afterEnv,
            afterRepair
        )
    }

    // 재료 비율을 기반으로 초기 내재탄소량 계산
    static func calculateCarbonEmission(materialRatios: [String: Double]) -> Int {
        var totalEmission: Double = 0
        for (material, ratio) in materialRatios {
            let emissionPerUnit = CarbonDatabase.unitEmissions[material] ?? 0
            totalEmission += emissionPerUnit * (ratio / 100.0)
        }
        return Int(totalEmission.rounded())
    }
}
