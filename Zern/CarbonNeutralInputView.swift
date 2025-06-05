//
//  CarbonNeutralInputView.swift
//  BuildLifeCycle
//
//  Created by Juliana Lee on 6/4/25.
//

import SwiftUI

struct CarbonNeutralInputView: View {
    var preLifeSpan: Int? = nil
    var preEmbeddedCarbon: Double? = nil

    @State private var buildingArea: String = ""
    @State private var energyUsage: String = ""
    @State private var emissionFactor: String = "" // kgCO₂/kWh
    @State private var lifeSpan: String = ""
    @State private var offsetPeriod: String = ""
    @State private var selectedEnergySource: String = "태양광"

    let materialRatios: [String: Double] = [
        "철근콘크리트": 60.0,
        "철골": 40.0
    ]

    let energySources = ["태양광", "풍력", "지열", "바이오", "수력"]

    var body: some View {
        Form {
            Section(header: Text("기초 정보 입력")) {
                TextField("건물 연면적 (m²)", text: $buildingArea)
                    .keyboardType(.decimalPad)

                TextField("연간 에너지 소비량 (kWh)", text: $energyUsage)
                    .keyboardType(.decimalPad)

                TextField("전력 탄소계수 (kgCO₂/kWh)", text: $emissionFactor)
                    .keyboardType(.decimalPad)

                TextField("건물 생애주기 (년)", text: $lifeSpan)
                    .keyboardType(.numberPad)

                TextField("탄소 상쇄 목표 기간 (년)", text: $offsetPeriod)
                    .keyboardType(.numberPad)

                Picker("설치할 신재생에너지", selection: $selectedEnergySource) {
                    ForEach(energySources, id: \.self) { source in
                        Text(source)
                    }
                }
                .pickerStyle(.menu)
            }

            NavigationLink(destination:
                CarbonNeutralResultView(
                    materialRatios: materialRatios,
                    buildingArea: Double(buildingArea) ?? 0,
                    energyUse: Double(energyUsage) ?? 0,
                    emissionFactor: Double(emissionFactor) ?? 0,
                    lifeSpan: Int(lifeSpan) ?? 0,
                    offsetPeriod: Int(offsetPeriod) ?? 0,
                    energySource: selectedEnergySource
                )
            ) {
                Text("계산하기")
                    .foregroundColor(.green)
            }
        }
        .navigationTitle("탄소중립 시뮬레이터")
        .onAppear {
            // 외부 전달값 반영
            if let pre = preLifeSpan {
                lifeSpan = "\(pre)"
            }
        }
    }
}
