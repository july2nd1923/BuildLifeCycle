//
//  BarChartView.swift
//  BuildLifeCycle
//
//  Created by Juliana on 6/3/25.
//

import SwiftUI
import Charts

// 수명 단계별 막대그래프 시각화 뷰
struct BarChartView: View {
    // 예: [("Base", 25), ("After Env", 30), ...]
    var stages: [(label: String, value: Int)]

    var body: some View {
        Chart {
            // 단계별 막대 생성
            ForEach(stages, id: \.label) { stage in
                BarMark(
                    x: .value("Stage", stage.label),
                    y: .value("Lifespan", stage.value)
                )
                .foregroundStyle(.blue) // 막대 색상
            }
        }
        .frame(height: 250) // 전체 차트 높이 설정
        .padding()
    }
}
