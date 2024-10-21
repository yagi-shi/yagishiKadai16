import SwiftUI

struct ModalView: View {
    enum ModalMode {
        case add
        case edit
    }

    @Environment (\.presentationMode) var presentation
    //　保存用の処理
    var onSave: (String) -> Void = { (name: String) -> Void in }
    //　更新用の処理
    var onUpdate: (String) -> Void = { (name: String) -> Void in }

    // @Bindingは「親ビューから受け取った状態をバインドして保持する」ためのものなため、初期値を与えることはできない。（初期値は親ビューから！）
    var modalMode: ModalMode

    @State var name: String

    var body: some View {
        NavigationStack {
            HStack {
                Text("名前")

                TextField("", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 200)
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
                        guard !name.isEmpty else { return }

                        switch modalMode {
                        case .add:
                            onSave(name)
                        case .edit:
                            onUpdate(name)
                        }

                        presentation.wrappedValue.dismiss()
                    }
                }
            }
            Spacer(minLength: 50)
        }
    }
}

