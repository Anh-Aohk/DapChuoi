//
//  ContentView.swift
//  DapChuoi
//
//  Created by Phạm Anh Khoa on 5/9/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    var body: some View {
        MainMenuView()
            .environmentObject(viewModel)
    }
}

#Preview {
    ContentView().environmentObject(GameViewModel())
}
