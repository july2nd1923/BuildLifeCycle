//
//  BuildingInputView.swift
//  BuildLifeCycle
//
//  Created by Juliana Lee on 6/3/25.
//
import SwiftUI

struct BuildingInputView: View {
    @State private var yearBuilt: String = ""
    @State private var selectedMaterials: [String: Double] = [:]
    @State private var floors: Int = 1
    @State private var usage: String = "주거용"
    @State private var environment: String = "일반"

    @State private var recentlyRepaired: Bool = false
    @State private var hasCracks: Bool = false
    @State private var hasLeakage: Bool = false
    @State private var hasCorrosion: Bool = false

    @State private var materialLives: [String: String] = [
        "철근콘크리트": "",
        "철골": "",
        "조적": "",
        "목조": ""
    ]
    
    let usages = ["주거용", "상업용", "공공시설", "기타"]
    
    var body: some View {
        Form {
            Section(header: Text("기본 정보")) {
                TextField("시공년도", text: $yearBuilt)
                    .keyboardType(.numberPad)
                
                Picker("주 용도", selection: $usage) {
                    ForEach(usages, id: \.self) { Text($0) }
                }
                
                Stepper(value: $floors, in: 1...100) {
                    Text("층수: \(floors)층")
                }
            }

            MaterialInput(selectedMaterials: $selectedMaterials)

            Section(header: Text("재료별 기준 수명(년)")) {
                ForEach(materialLives.keys.sorted(), id: \.self) { material in
                    TextField("\(material)", text: Binding(
                        get: { materialLives[material] ?? "" },
                        set: { materialLives[material] = $0 }
                    ))
                    .keyboardType(.numberPad)
                }
            }

            Section(header: Text("건물 위치 환경")) {
                Picker("환경 조건", selection: $environment) {
                    ForEach(["일반", "해안 지역", "지진대", "고온다습", "고산건조"], id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
            }

            Section(header: Text("유지관리 및 점검 상태")) {
                Toggle("최근 5년 내 보수 이력 있음", isOn: $recentlyRepaired)
                Toggle("구조체 균열 있음", isOn: $hasCracks)
                Toggle("누수 흔적 있음", isOn: $hasLeakage)
                Toggle("철근 부식 있음", isOn: $hasCorrosion)
            }

            NavigationLink(
                destination: PredictionResultView(
                    yearBuilt: yearBuilt,
                    materialRatios: selectedMaterials,
                    usage: usage,
                    floors: floors,
                    materialLives: materialLives.mapValues { Int($0) ?? 0 },
                    environment: environment,
                    recentlyRepaired: recentlyRepaired,
                    hasCracks: hasCracks,
                    hasLeakage: hasLeakage,
                    hasCorrosion: hasCorrosion
                )
            ) {
                Text("예측 시작")
                    .foregroundColor(.blue)
            }
        }
        .navigationTitle("건물 정보 입력")
    }
}
