import SwiftUI

struct ModalView: View {
    @State var newFruit: String = ""
    @Environment (\.presentationMode) var presentation
    //　保存用の処理
    var onSave: (String) -> Void = { (name: String) -> Void in }
    //　更新用の処理
    var onUpdate: (String) -> Void = { (name: String) -> Void in }

    // @Bindingは「親ビューから受け取った状態をバインドして保持する」ためのものなため、初期値を与えることはできない。（初期値は親ビューから！）
    @Binding var modalMode: ContentView.ModalMode
    @Binding var selectedFruit: String

    var body: some View {
        NavigationStack {
            HStack {
                Text("名前")
                if modalMode == .add {
                    TextField("", text: $newFruit)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                } else if modalMode == .edit {
                    TextField("", text: $selectedFruit)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                }
            }
            .offset(x: 0, y: 50)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        presentation.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        if modalMode == .add && !newFruit.isEmpty {
                            onSave(newFruit)
                        }
                        if modalMode == .edit && !selectedFruit.isEmpty {
                            onUpdate(selectedFruit)
                        }
                        presentation.wrappedValue.dismiss()
                    }
                }
            }
            Spacer(minLength: 50)
        }
    }
}

