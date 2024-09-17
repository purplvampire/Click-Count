//
//  TapData.swift
//  Click&Count
//
//  Created by 陳信彰 on 2024/9/17.
//

import Foundation

class TapeDataManager: Codable {
    // Singleton
    static let shared = TapeDataManager()
    private init() {}
    
    let documentDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func saveTapeData(_ tapData: [Date]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(tapData) else { return }
        let url = documentDirectory.appendingPathComponent("tapData.json")
        try? data.write(to: url)
//        UserDefaults.standard.set(data, forKey: "tapData")
    }
    
    func loadTapeData() -> [Date]? {
//        guard let data = UserDefaults.standard.data(forKey: "tapData") else { return nil }
        let url = documentDirectory.appendingPathComponent("tapData.json")
        guard let data = try? Data(contentsOf: url) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode([Date].self, from: data)
    }
    
}
