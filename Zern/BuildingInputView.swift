//
//  BuildingInputView.swift
//  BuildLifeCycle
//
//  Created by Juliana Lee on 6/3/25.
//

import SwiftUI

struct BuildingInputView: View {
    // 사용자 입력을 위한 상태 변수들
    @State private var constructionYear: String = "" // 시공년도
    @State private var materialRatios: [String: Double] = [:] // 재료 비율
    @State private var numberOfFloors: Int = 1 // 층수
    @State private var buildingUsage: String = "Residential" // 주 용도
    @State private var environmentCondition: String = "Normal" // 환경 조건

    // 유지보수 및 결함 상태
    @State private var wasRecentlyRepaired: Bool = false
    @State private var hasStructuralCracks: Bool = false
    @State private var hasWaterLeakage: Bool = false
    @State private var hasRebarCorrosion: Bool = false

    // 재료별 기대 수명 (텍스트 입력 후 Int로 변환 예정)
    @State private var materialLifeExpectancies: [String: String] = [
        "Reinforced Concrete": "",
        "Steel": "",
        "Masonry": "",
        "Wood": ""
    ]
    
    let usageOptions = ["Residential", "Commercial", "Public", "Other"]
    
    var body: some View {
        
        let materialOrder = ["Reinforced Concrete", "Steel", "Masonry", "Wood"]

        Form {
            // 기본 정보 입력 섹션
            Section(header: Text("Basic Information")) {
                TextField("Year Built", text: $constructionYear)
                    .keyboardType(.numberPad)
                
                Picker("Main Usage", selection: $buildingUsage) {
                    ForEach(usageOptions, id: \.self) { Text($0) }
                }
                
                Stepper(value: $numberOfFloors, in: 1...100) {
                    Text("Floors: \(numberOfFloors)")
                }
            }

            // 재료 비율 입력 섹션 (별도 컴포넌트로 구성)
            MaterialInput(selectedMaterials: $materialRatios)

            // 재료별 기준 수명 입력 섹션
            Section(header: Text("Expected Life Span by Material (years)")) {
                ForEach(materialOrder, id: \.self) { material in
                    TextField("\(material)", text: Binding(
                        get: { materialLifeExpectancies[material] ?? "" },
                        set: { materialLifeExpectancies[material] = $0 }
                    ))
                    .keyboardType(.numberPad)
                }
            }

            // 환경 조건 선택 섹션
            Section(header: Text("Environmental Condition")) {
                Picker("Environment", selection: $environmentCondition) {
                    ForEach(["Normal", "Coastal", "Seismic Zone", "Hot and Humid", "High-altitude Dry"], id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
            }

            // 유지관리 및 결함 여부
            Section(header: Text("Maintenance and Inspection")) {
                Toggle("Repaired within last 5 years", isOn: $wasRecentlyRepaired)
                Toggle("Structural Cracks Present", isOn: $hasStructuralCracks)
                Toggle("Water Leakage Signs", isOn: $hasWaterLeakage)
                Toggle("Rebar Corrosion Detected", isOn: $hasRebarCorrosion)
            }

            // 예측 시작 버튼 → PredictionResultView로 이동
            NavigationLink(
                destination: PredictionResultView(
                    yearBuilt: constructionYear,
                    materialRatios: materialRatios,
                    usage: buildingUsage,
                    floors: numberOfFloors,
                    materialLives: materialLifeExpectancies.mapValues { Int($0) ?? 0 },
                    environment: environmentCondition,
                    recentlyRepaired: wasRecentlyRepaired,
                    hasCracks: hasStructuralCracks,
                    hasLeakage: hasWaterLeakage,
                    hasCorrosion: hasRebarCorrosion
                )
            ) {
                Text("Start Prediction")
                    .foregroundColor(.blue)
            }
        }
        .navigationTitle("Enter Building Info")
    }
}
