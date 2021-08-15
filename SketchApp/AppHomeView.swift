//
//  AppHomeView.swift
//  SketchApp
//
//  Created by KANISHK VIJAYWARGIYA on 15/08/21.
//
//
//  ContentView.swift
//  SketchApp
//
//  Created by KANISHK VIJAYWARGIYA on 15/08/21.
//

import SwiftUI
import CoreData
import Combine

struct AppHomeView: View {
    @EnvironmentObject var appLockVM: AppLockViewModel
    
    @AppStorage("isDarkMode") var  isDarkMode: Bool = false
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Drawing.entity(), sortDescriptors: []) var drawings: FetchedResults<Drawing>
    
    @State private var showSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(drawings, id: \.self) { drawing in
                        NavigationLink(destination: DrawingView(id: drawing.id, data: drawing.canvasData, title: drawing.title)) {
                            Text(drawing.title ?? "Untitled")
                        }
                    }
                    .onDelete(perform: deleteItem)
                }
                .navigationTitle("Draw With Us")
                .toolbar {
                    EditButton()
                }
                
                Toggle(isOn: $isDarkMode) {
                    Text("Dark Mode")
                        .font(.system(size: 14, weight: .semibold))
                }.padding()
                
                
                Toggle(isOn: $appLockVM.isAppLockEnabled) {
                    Text("App Lock")
                        .font(.system(size: 14, weight: .semibold))
                }
                .onChange(of: appLockVM.isAppLockEnabled, perform: { value in
                    appLockVM.appLockStateChange(appLockState: value)
                })
                .padding()
                
                
                Button(action: {self.showSheet.toggle()}) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Canvas").font(.system(size: 14, weight: .semibold))
                    }
                }
                .sheet(isPresented: $showSheet) {
                    AddNewCanvasView().environment(\.managedObjectContext, viewContext)
                }
            }
            
            VStack {
                Image(systemName: "scribble.variable")
                    .font(.largeTitle)
                Text("No canvas has been selected")
                    .font(.title)
            }
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
    
    func deleteItem(at offset: IndexSet) {
        for index in offset {
            let itemToDelete = drawings[index]
            viewContext.delete(itemToDelete)
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        }
    }
}

struct AppHomeView_Previews: PreviewProvider {
    static var previews: some View {
        AppHomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
