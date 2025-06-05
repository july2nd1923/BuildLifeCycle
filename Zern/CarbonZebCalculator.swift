//
//  CarbonZebCalculator.swift
//  BuildLifeCycle
//
//  Created by Juliana Lee on 6/5/25.
//

import Foundation

struct CarbonZebCalculator {
    static func calculateAll(
        materialRatios: [String: Double],
        buildingArea: Double,
        energyUse: Double,             // kWh/year
        emissionFactor: Double,       // kgCO₂/kWh
        lifeSpan: Int,
        offsetPeriod: Int,
        energySource: String,
        reductionFactor: Double = 0.45,
        installAreaPerKW: Double = 3.5
    ) -> ZebResult {
        // 1. 내재탄소 계산
        let embeddedCarbon = materialRatios.reduce(0.0) { partialResult, entry in
            let material = entry.key
            let ratio = entry.value / 100.0
            let factor = CarbonDatabase.unitCarbonPerArea[material] ?? 0.0
            return partialResult + ratio * factor * buildingArea
        }

        // 2. 운영탄소 예측
        let operatingCarbonPerYear = energyUse * emissionFactor

        // 3. 총 탄소배출량
        let totalCarbon = embeddedCarbon + Double(lifeSpan) * operatingCarbonPerYear

        // 4. 선택된 신재생에너지의 연간 발전량 설정
        let generationPerKW = generationFactor(for: energySource)
        let annualOffsetTarget = totalCarbon / Double(offsetPeriod)
        let annualEnergyNeeded = annualOffsetTarget / reductionFactor
        let requiredKW = annualEnergyNeeded / generationPerKW
        let requiredArea = requiredKW * installAreaPerKW

        // 5. 누적 상쇄량 계산
        var cumulativeOffset: Double = 0.0
        var offsetData: [(year: Int, cumulative: Double)] = []
        let currentYear = Calendar.current.component(.year, from: Date())
        let annualOffset = generationPerKW * requiredKW * reductionFactor
        var offsetYear: Int? = nil

        for i in 0..<lifeSpan {
            cumulativeOffset += annualOffset
            let year = currentYear + i
            offsetData.append((year: year, cumulative: cumulativeOffset))
            if offsetYear == nil && cumulativeOffset >= totalCarbon {
                offsetYear = year
            }
        }

        let isZEB = (offsetYear != nil && offsetYear! <= currentYear + lifeSpan)

        return ZebResult(
            embeddedCarbon: embeddedCarbon,
            operatingCarbonPerYear: operatingCarbonPerYear,
            totalCarbon: totalCarbon,
            annualOffsetTarget: annualOffsetTarget,
            annualEnergyNeeded: annualEnergyNeeded,
            requiredKW: requiredKW,
            requiredArea: requiredArea,
            offsetYear: offsetYear,
            isZEB: isZEB,
            offsetData: offsetData,
            annualOffset: annualOffset
        )
    }

    private static func generationFactor(for source: String) -> Double {
        switch source {
        case "태양광": return 1460     // 하루 4시간 × 365일
        case "풍력":   return 2190     // 하루 6시간 × 365일
        case "지열":   return 2630     // 7.2시간 기준
        case "바이오":  return 2920     // 8시간 기준
        case "수력":   return 4380     // 12시간 기준
        default:       return 1460     // 기본값: 태양광
        }
    }
}

struct ZebResult {
    let embeddedCarbon: Double
    let operatingCarbonPerYear: Double
    let totalCarbon: Double
    let annualOffsetTarget: Double
    let annualEnergyNeeded: Double
    let requiredKW: Double
    let requiredArea: Double
    let offsetYear: Int?
    let isZEB: Bool
    let offsetData: [(year: Int, cumulative: Double)]
    let annualOffset: Double
}
