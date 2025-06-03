//
//  ContentView.swift
//  BuildLifeCycle
//
//  Created by Juliana Lee on 6/3/25.
//

// ✅ 1. ContentView.swift
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

                NavigationLink(destination: CarbonNeutralInputView()) {
                    Text("탄소중립 시뮬레이터")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

// ✅ 2. CarbonNeutralCalculator.swift
import Foundation

struct CarbonNeutralCalculator {
    static func calculate(
        embeddedCarbon: Double,
        operatingCarbonPerYear: Double,
        lifeSpan: Int,
        offsetPeriod: Int,
        reductionFactor: Double = 0.45, // kgCO₂/kWh (태양광 기준)
        dailyGeneration: Double = 4.0,   // kWh/day per kW
        installAreaPerKW: Double = 3.5  // m² per kW
    ) -> (totalCarbon: Double, annualOffset: Double, requiredEnergy: Double, requiredKW: Double, requiredArea: Double) {

        let totalCarbon = embeddedCarbon + (operatingCarbonPerYear * Double(lifeSpan))
        let annualOffset = totalCarbon / Double(offsetPeriod)
        let requiredEnergy = annualOffset / reductionFactor
        let requiredKW = requiredEnergy / (365.0 * dailyGeneration)
        let requiredArea = requiredKW * installAreaPerKW

        return (totalCarbon, annualOffset, requiredEnergy, requiredKW, requiredArea)
    }
}

// ✅ 3. CarbonNeutralInputView.swift
import SwiftUI

struct CarbonNeutralInputView: View {
    @State private var embeddedCarbon: String = ""
    @State private var operatingCarbon: String = ""
    @State private var lifeSpan: String = "50"
    @State private var offsetPeriod: String = "20"

    var body: some View {
        Form {
            Section(header: Text("기초 정보 입력")) {
                TextField("내재탄소량 (kg CO₂)", text: $embeddedCarbon)
                    .keyboardType(.decimalPad)
                TextField("연간 운영탄소량 (kg CO₂)", text: $operatingCarbon)
                    .keyboardType(.decimalPad)
                TextField("건물 생애주기 (년)", text: $lifeSpan)
                    .keyboardType(.numberPad)
                TextField("탄소 상쇄 목표 기간 (년)", text: $offsetPeriod)
                    .keyboardType(.numberPad)
            }

            NavigationLink(destination:
                CarbonNeutralResultView(
                    embeddedCarbon: Double(embeddedCarbon) ?? 0,
                    operatingCarbonPerYear: Double(operatingCarbon) ?? 0,
                    lifeSpan: Int(lifeSpan) ?? 50,
                    offsetPeriod: Int(offsetPeriod) ?? 20
                )
            ) {
                Text("계산하기")
                    .foregroundColor(.green)
            }
        }
        .navigationTitle("탄소중립 시뮬레이터")
    }
}

// ✅ 4. CarbonNeutralResultView.swift
import SwiftUI

struct CarbonNeutralResultView: View {
    var embeddedCarbon: Double
    var operatingCarbonPerYear: Double
    var lifeSpan: Int
    var offsetPeriod: Int

    var body: some View {
        let result = CarbonNeutralCalculator.calculate(
            embeddedCarbon: embeddedCarbon,
            operatingCarbonPerYear: operatingCarbonPerYear,
            lifeSpan: lifeSpan,
            offsetPeriod: offsetPeriod
        )

        VStack(alignment: .leading, spacing: 12) {
            Text("📊 탄소중립 계산 결과")
                .font(.title2)
                .bold()

            Text("총 탄소배출량: \(String(format: "%.1f", result.totalCarbon)) kg CO₂")
            Text("연간 상쇄 목표량: \(String(format: "%.1f", result.annualOffset)) kg CO₂/년")
            Text("필요한 재생에너지 발전량: \(String(format: "%.1f", result.requiredEnergy)) kWh/년")
            Text("필요 발전 용량: \(String(format: "%.2f", result.requiredKW)) kW")
            Text("필요 설치 면적: \(String(format: "%.2f", result.requiredArea)) ㎡")

            Spacer()
        }
        .padding()
        .navigationTitle("결과 보기")
    }
}
