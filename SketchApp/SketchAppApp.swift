//
//  SketchAppApp.swift
//  SketchApp
//
//  Created by KANISHK VIJAYWARGIYA on 15/08/21.
//

import SwiftUI

@main
struct SketchAppApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var appLockVM = AppLockViewModel()
    @Environment(\.scenePhase) var scenePhase
    
    @State var blurRadius: CGFloat = 0
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appLockVM)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .modifier(DarkModeViewModifier())
                .blur(radius: blurRadius)
                .onChange(of: scenePhase) { value in
                    switch value {
                    case .active: blurRadius = 0
                    case .background: appLockVM.isAppUnlock = false
                    case .inactive: blurRadius = 5
                    @unknown default: print("unknown")
                    }
                }
        }
    }
}
