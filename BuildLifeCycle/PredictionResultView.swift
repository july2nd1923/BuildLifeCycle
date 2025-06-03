//
//  PredictionResultView.swift
//  BuildLifeCycle
//
//  Created by Juliana Lee on 6/3/25.
//
import SwiftUI

struct PredictionResultView: View {
    var yearBuilt: String
    var material: String
    var usage: String
    var floors: Int
    
    var body: some View {
        let predictedLife = LifeCyclePredictor.predict(yearBuilt: yearBuilt, material: material, usage: usage, floors: floors)
        
        VStack(spacing: 20) {
            Text("예상 건물 수명: \(predictedLife)년")
                .font(.title)
                .bold()
            
            Text("추천 리모델링 시점: \(predictedLife / 2)년 후")
                .foregroundColor(.gray)
            
            Spacer()
        }
        .padding()
        .navigationTitle("예측 결과")
    }
}

