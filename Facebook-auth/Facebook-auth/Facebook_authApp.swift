//
//  Facebook_authApp.swift
//  Facebook-auth
//
//  Created by abhishek on 28/07/23.
//

import SwiftUI
import FacebookCore

@main
struct Facebook_authApp: App {

    
    var body: some Scene {
        WindowGroup {
            ContentView()
           
                .onAppear(){
                ApplicationDelegate.shared.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
                               }
        }
    }
}
