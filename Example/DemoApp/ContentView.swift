//
//  ContentView.swift
//  DemoApp
//
//  Created by Itay Brenner on 9/10/24.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack(spacing: 20.0) {
      Button("Check For Update Swift") {
        UpdateUtil.checkForUpdates()
      }
      .padding()
      .background(.blue)
      .foregroundColor(.white)
      .cornerRadius(10)
      
      Button("Check For Update With Login Swift") {
        UpdateUtil.checkForUpdatesWithLogin()
      }
      .padding()
      .background(.orange)
      .foregroundColor(.white)
      .cornerRadius(10)
        
      Button("Check For Update ObjC") {
        UpdateUtilObjc().checkForUpdates()
      }
      .padding()
      .background(.gray)
      .foregroundColor(.white)
      .cornerRadius(10)
      
      Button("Check For Update With Login ObjC") {
        UpdateUtilObjc().checkForUpdatesWithLogin()
      }
      .padding()
      .background(.yellow)
      .foregroundColor(.black)
      .cornerRadius(10)
      
      Button("Clear Tokens") {
        UpdateUtil.clearTokens()
      }
      .padding()
      .background(.mint)
      .foregroundColor(.black)
      .cornerRadius(10)
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
