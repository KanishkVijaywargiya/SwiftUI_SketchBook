//
//  ContentView.swift
//  SketchApp
//
//  Created by KANISHK VIJAYWARGIYA on 15/08/21.
//

import SwiftUI
import CoreData
import Combine

struct ContentView: View {
    @EnvironmentObject var appLockVM: AppLockViewModel
    
    var body: some View {
        ZStack {
            if !appLockVM.isAppLockEnabled || appLockVM.isAppUnlock {
                AppHomeView()
                    .environmentObject(appLockVM)
            } else {
                AppLockView()
                    .environmentObject(appLockVM)
            }
        }
        .onAppear {
            if appLockVM.isAppLockEnabled {
                appLockVM.appLockValidation()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
