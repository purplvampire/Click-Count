//
//  CustomSetup.swift
//  Click&Count
//
//  Created by 陳信彰 on 2024/7/24.
//

import Foundation
import UIKit


class UserDefaultsManager {
    
    // Singleton
    static let shared = UserDefaultsManager()
    private init() {}
    
    // Create UserDefault key, avoid using hardcode
    private let themeColorKey = "themeColorKey"
    private let soundEnableKey = "soundEnableKey"
    private let waveEnableKey = "waveEnableKey"
    
    // 設定Theme Color
    func getThemeColor() -> String {
        
        let savedThemeColor = UserDefaults.standard.string(forKey: themeColorKey) ?? "black"
        
        return savedThemeColor
    }
    
    func setThemeColor(_ color: String) {
        
        UserDefaults.standard.set(color, forKey: themeColorKey)
        
    }
    
    // 設定音效
    func getSoundEnable() -> Bool {
        
        let savedSoundEnable = UserDefaults.standard.bool(forKey: soundEnableKey)
        
        return savedSoundEnable
    }
    
    func setSoundEnable(_ enable: Bool) {
        
        UserDefaults.standard.set(enable, forKey: soundEnableKey)
    }
    
    // 設定震動
    func getWaveEnable() -> Bool {
        
        let savedWaveEnable = UserDefaults.standard.bool(forKey: waveEnableKey)
        
        return savedWaveEnable
    }
    
    func setWaveEnable(_ enable: Bool) {
        
        UserDefaults.standard.set(enable, forKey: waveEnableKey)
    }
}
