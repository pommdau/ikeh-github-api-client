//
//  ContentView.swift
//  IKEHGitHubAPIClientExample
//
//  Created by HIROKI IKEUCHI on 2025/04/16.
//

import SwiftUI
import IKEHGitHubAPIClient

struct ContentView: View {
    
    @AppStorage("selectedTab")
    private var selectedTab = 0
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            Tab("Login", systemImage: "person", value: 0) {
                LoginView()
            }
            Tab("Seaerch", systemImage: "magnifyingglass", value: 1) {
                SearchReposView()
            }
            Tab("Star", systemImage: "star", value: 2) {
                StarView()
            }            
        }
    }
}

#Preview {
    ContentView()
}
