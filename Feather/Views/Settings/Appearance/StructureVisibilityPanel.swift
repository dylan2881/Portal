import SwiftUI

// MARK: - Left Panel: Structure & Visibility
struct StructureVisibilityPanel: View {
    @ObservedObject var viewModel: StatusBarViewModel
    @State private var showConfigureLayouts = false
    @State private var showSavedStyles = false
    
    var body: some View {
        List {
            Section(header: Text("Visibility")) {
                Toggle("Show Custom Text", isOn: $viewModel.showCustomText)
                Toggle("Show SF Symbol", isOn: $viewModel.showSFSymbol)
            }
            
            Section(header: Text("Saved Styles")) {
                Button {
                    showSavedStyles = true
                } label: {
                    HStack {
                        Image(systemName: "bookmark.fill")
                            .foregroundStyle(.blue)
                        Text("Manage Saved Styles")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Section(header: Text("Layout Configuration")) {
                Button {
                    showConfigureLayouts = true
                } label: {
                    HStack {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundStyle(.blue)
                        Text("Configure Layouts")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Section(header: Text("System Integration")) {
                Toggle("Hide Default Status Bar", isOn: $viewModel.hideDefaultStatusBar)
                    .onChange(of: viewModel.hideDefaultStatusBar) { newValue in
                        viewModel.handleHideDefaultStatusBarChange(newValue)
                    }
            }
        }
        .listStyle(.insetGrouped)
        .sheet(isPresented: $showConfigureLayouts) {
            ConfigureLayoutsView(viewModel: viewModel)
        }
        .sheet(isPresented: $showSavedStyles) {
            SavedStylesView(viewModel: viewModel)
        }
    }
}
