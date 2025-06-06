//
//  CarbonDatabase.swift
//  BuildLifeCycle
//
//  Created by 김재현 on 6/3/25.
//

import Foundation

struct CarbonDatabase {
    // [1] 재료 비율 기준 단위 탄소배출량 (단위: kg CO₂)
    static let unitEmissions: [String: Double] = [
        "Reinforced Concrete": 300,
        "Steel": 11000,
        "Masonry": 500,
        "Wood": 150
    ]

    // [2] 재료 단위 면적당 내재탄소량 (단위: kg CO₂ / ㎡)
    static let unitCarbonPerArea: [String: Double] = [
        "Reinforced Concrete": 320.0,
        "Steel": 980.0,
        "Masonry": 250.0,
        "Wood": 120.0
    ]
}
