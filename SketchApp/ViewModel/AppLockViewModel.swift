//
//  AppLockViewModel.swift
//  SketchApp
//
//  Created by KANISHK VIJAYWARGIYA on 15/08/21.
//

import SwiftUI
import LocalAuthentication

class AppLockViewModel: ObservableObject {
    @Published var isAppLockEnabled: Bool = false
    @Published var isAppUnlock: Bool = false
    
    init() {
        getAppLockStatus()
    }
    
    func enableAppLock() {
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.isAppLockEnabled.rawValue)
        self.isAppLockEnabled = true
    }
    
    func disableAppLock() {
        UserDefaults.standard.set(false, forKey: UserDefaultKeys.isAppLockEnabled.rawValue)
        self.isAppLockEnabled = false
    }
    
    func getAppLockStatus() {
        isAppLockEnabled = UserDefaults.standard.bool(forKey: UserDefaultKeys.isAppLockEnabled.rawValue)
    }
    
    func checkIfBiometricAvailable() -> Bool {
        var error: NSError?
        let laContext = LAContext()
        let isBiometricAvailable = laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if let error = error {
            print(error.localizedDescription)
        }
        
        return isBiometricAvailable
    }
    
    func appLockStateChange(appLockState: Bool) {
        let laContext = LAContext()
        if checkIfBiometricAvailable() {
            var reason = ""
            if appLockState {
                reason = "Provide TouchID or FaceID to enable App Lock"
            } else {
                reason = "Provide TouchID or FaceID to disable App Lock"
            }
            laContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if success {
                    if appLockState {
                        DispatchQueue.main.async {
                            self.enableAppLock()
                            self.isAppUnlock = true
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.disableAppLock()
                            self.isAppUnlock = true
                        }
                    }
                } else {
                    if let error = error {
                        DispatchQueue.main.async {
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    func appLockValidation() {
        let laContext = LAContext()
        if checkIfBiometricAvailable() {
            let reason = "Enable App Lock"
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if success {
                    DispatchQueue.main.async {
                        self.isAppUnlock = true
                    }
                } else {
                    if let error = error {
                        DispatchQueue.main.async {
                            print(error)
                        }
                    }
                }
            }
        }
    }
}

enum UserDefaultKeys:String {
    case isAppLockEnabled
}




