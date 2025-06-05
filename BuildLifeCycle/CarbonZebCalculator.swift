//
//  CarbonZebCalculator.swift
//  BuildLifeCycle
//
//  Created by Juliana Lee on 6/5/25.
//

// ✅ CarbonZebCalculator.swift
import Foundation

struct CarbonZebCalculator {
    static func calculateAll(
        materialRatios: [String: Double],
        buildingArea: Double,
        operatingCarbonPerYear: Double,
        lifeSpan: Int,
        offsetPeriod: Int,
        reductionFactor: Double = 0.45, // kgCO₂/kWh
        dailyGeneration: Double = 4.0,  // kWh/day/kW
        installAreaPerKW: Double = 3.5
    ) -> ZebResult {

        let embeddedCarbon = materialRatios.reduce(0.0) { partialResult, entry in
            let material = entry.key
            let ratio = entry.value / 100.0
            let factor = CarbonDatabase.unitCarbonPerArea[material] ?? 0.0
            return partialResult + ratio * factor * buildingArea
        }

        let totalCarbon = embeddedCarbon + Double(lifeSpan) * operatingCarbonPerYear
        let annualOffsetTarget = totalCarbon / Double(offsetPeriod)
        let annualEnergyNeeded = annualOffsetTarget / reductionFactor
        let requiredKW = annualEnergyNeeded / (365.0 * dailyGeneration)
        let requiredArea = requiredKW * installAreaPerKW

        let currentYear = Calendar.current.component(.year, from: Date())
        var cumulativeOffset: Double = 0.0
        var offsetData: [(year: Int, cumulative: Double)] = []
        var offsetYear: Int? = nil

        for i in 0..<lifeSpan {
            cumulativeOffset += annualOffsetTarget
            let year = currentYear + i
            offsetData.append((year: year, cumulative: cumulativeOffset))
            if offsetYear == nil && cumulativeOffset >= totalCarbon {
                offsetYear = year
            }
        }

        let isZEB = (offsetYear != nil && offsetYear! <= currentYear + lifeSpan)

        return ZebResult(
            embeddedCarbon: embeddedCarbon,
            totalCarbon: totalCarbon,
            annualOffsetTarget: annualOffsetTarget,
            annualEnergyNeeded: annualEnergyNeeded,
            requiredKW: requiredKW,
            requiredArea: requiredArea,
            offsetYear: offsetYear,
            isZEB: isZEB,
            offsetData: offsetData
        )
    }
}

struct ZebResult {
    let embeddedCarbon: Double
    let totalCarbon: Double
    let annualOffsetTarget: Double
    let annualEnergyNeeded: Double
    let requiredKW: Double
    let requiredArea: Double
    let offsetYear: Int?
    let isZEB: Bool
    let offsetData: [(year: Int, cumulative: Double)]
}

// ✅ CarbonNeutralResultView.swift
import SwiftUI

struct CarbonNeutralResultView: View {
    var materialRatios: [String: Double]
    var buildingArea: Double
    var operatingCarbonPerYear: Double
    var lifeSpan: Int
    var offsetPeriod: Int

    var body: some View {
        let result = CarbonZebCalculator.calculateAll(
            materialRatios: materialRatios,
            buildingArea: buildingArea,
            operatingCarbonPerYear: operatingCarbonPerYear,
            lifeSpan: lifeSpan,
            offsetPeriod: offsetPeriod
        )

        VStack(alignment: .leading, spacing: 12) {
            Text("📊 탄소중립 계산 결과")
                .font(.title2)
                .bold()

            Text("1️⃣ 내재탄소량: \(String(format: "%.1f", result.embeddedCarbon)) kg CO₂")
            Text("2️⃣ 총 탄소배출량 (내재 + 운영): \(String(format: "%.1f", result.totalCarbon)) kg CO₂")
            Text("3️⃣ 연간 상쇄 목표량: \(String(format: "%.1f", result.annualOffsetTarget)) kg CO₂/년")
            Text("4️⃣ 필요한 재생에너지 발전량: \(String(format: "%.1f", result.annualEnergyNeeded)) kWh/년")
            Text("5️⃣ 발전 용량: \(String(format: "%.2f", result.requiredKW)) kW, 면적: \(String(format: "%.2f", result.requiredArea)) ㎡")

            if let year = result.offsetYear {
                Text("6️⃣ 예상 상쇄 완료 연도: \(year)년")
            } else {
                Text("6️⃣ 예상 상쇄 완료 연도: 생애주기 내 달성 불가")
            }

            Text("7️⃣ ZEB 가능 여부: \(result.isZEB ? "✅ 가능" : "❌ 불가")")

            Spacer()
        }
        .padding()
        .navigationTitle("결과 보기")
    }
}
