//
//  BuildingInputView.swift
//  BuildLifeCycle
//
//  Created by Juliana Lee on 6/3/25.
//
import SwiftUI

struct BuildingInputView: View {
    @State private var yearBuilt: String = ""
    @State private var material: String = "철근콘크리트"
    @State private var floors: Int = 1
    @State private var usage: String = "주거용"
    
    let materials = ["철근콘크리트", "철골", "조적", "목조"]
    let usages = ["주거용", "상업용", "공공시설", "기타"]
    
    var body: some View {
        Form {
            Section(header: Text("기본 정보")) {
                TextField("시공년도", text: $yearBuilt)
                    .keyboardType(.numberPad)
                
                Picker("주 용도", selection: $usage) {
                    ForEach(usages, id: \.self) { Text($0) }
                }
                
                Picker("주 재료", selection: $material) {
                    ForEach(materials, id: \.self) { Text($0) }
                }
                
                Stepper(value: $floors, in: 1...100) {
                    Text("층수: \(floors)층")
                }
            }

            NavigationLink(destination: PredictionResultView(yearBuilt: yearBuilt, material: material, usage: usage, floors: floors)) {
                Text("예측 시작")
                    .foregroundColor(.blue)
            }
        }
        .navigationTitle("건물 정보 입력")
    }
}

