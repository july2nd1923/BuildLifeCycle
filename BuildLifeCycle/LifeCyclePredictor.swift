//
//  LifeCyclePredictor.swift
//  BuildLifeCycle
//
//  Created by Juliana Lee on 6/3/25.
//
import Foundation

struct LifeCyclePredictor {
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
        guard let builtYear = Int(yearBuilt), !materialRatios.isEmpty else { return (0, 0, 0, 0) }

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

        if usage == "공공시설" { baseLife += 10 }
        if floors >= 10 { baseLife += 5 }

        switch environment {
        case "해안 지역": baseLife -= 5
        case "지진대": baseLife -= 3
        case "고온다습": baseLife -= 2
        case "고산건조": baseLife -= 1
        default: break
        }
        let afterEnv = baseLife

        if recentlyRepaired { baseLife += 10 }
        if hasCracks { baseLife -= 5 }
        if hasLeakage { baseLife -= 3 }
        if hasCorrosion { baseLife -= 3 }

        let afterRepair = baseLife
        let currentYear = Calendar.current.component(.year, from: Date())
        let age = currentYear - builtYear
        return (max(baseLife - age, 0), base, afterEnv, afterRepair)
    }

    static func calculateCarbonEmission(materialRatios: [String: Double]) -> Int {
        var totalEmission: Double = 0
        for (material, ratio) in materialRatios {
            let emissionPerUnit = CarbonDatabase.unitEmissions[material] ?? 0
            totalEmission += emissionPerUnit * (ratio / 100.0)
        }
        return Int(totalEmission.rounded())
    }
}
