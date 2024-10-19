import SwiftUI

struct ContentView: View {
    @State var fruits: [(name: String, isSelected: Bool)] = [
        (name: "りんご", isSelected: false),
        (name: "みかん", isSelected: true),
        (name: "バナナ", isSelected: false),
        (name: "パイナップル", isSelected: true)
    ]

    // 列挙型(enum)を用いている場合は、「.~~」という記載になる。
    enum ModalMode: Identifiable {
        case add
        case edit(index: Int)

        var id: String {
            switch self {
            case .add:
                return "add"
            case let .edit(index: index):
                return "\(index)"
            }
        }
    }

    // @Stateには初期値が必要。またenumを使用している場合は、型を指定しないとエラーが出る。
    @State var modalMode: ModalMode?

    var body: some View {
        NavigationStack {
            List {
                // リストの編集をする場合はindexの情報が必要。下記だと直接編集できるようなイメージ。
                // ForEach($fruits, id: \.name) { $fruit in
                ForEach(fruits.indices, id: \.self) { index in
                    HStack {
                        Image(systemName: "checkmark")
                            .foregroundColor(.orange)
                        // 透明度(条件 ? 値が真 : 値が偽)->.opacityに1or0が渡っている
                            .opacity(fruits[index].isSelected ? 1 : 0)
                        Text(fruits[index].name)
                        Spacer()
                        (Image(systemName: "info.circle"))
                            .foregroundColor(.blue)
                            .onTapGesture {
                                modalMode = .edit(index: index)
                            }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        fruits[index].isSelected.toggle()
                    }
                }
            }
            .navigationTitle("果物リスト")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("+") {
                        modalMode = .add
                    }
                    .fullScreenCover(item: $modalMode) { modalMode in
                        switch modalMode {
                        case .add:
                            ModalView(
                                onSave: {
                                    fruits.append((name: $0, isSelected: false))
                                },
                                onUpdate: { _ in },
                                modalMode: .add,
                                name: ""
                            )
                        case let .edit(index: index):
                            ModalView(
                                onSave: { _ in },
                                onUpdate: { newName in
                                    fruits[index].name = newName
                                },
                                modalMode: .edit,
                                name: fruits[index].name
                            )
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    ContentView()
}

