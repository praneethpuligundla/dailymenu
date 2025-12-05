//
//  ContentView.swift
//  DailyMenu
//
//  Created on 11/29/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "fork.knife.circle.fill")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .font(.system(size: 60))
                
                Text("Daily Menu")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Your daily meal planner")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

#Preview {
    ContentView()
}
