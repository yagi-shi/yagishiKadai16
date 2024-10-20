import SwiftUI

struct ContentView: View {
    @State var isShowModal = false
    @State var fruits: [(name: String, isSelected: Bool)] = [
        (name: "りんご", isSelected: false),
        (name: "みかん", isSelected: true),
        (name: "バナナ", isSelected: false),
        (name: "パイナップル", isSelected: true)
    ]

    // 列挙型(enum)を用いている場合は、「.~~」という記載になる。
    enum ModalMode {
        case add
        case edit
    }

    // @Stateには初期値が必要。またenumを使用している場合は、型を指定しないとエラーが出る。
    @State var modalMode: ModalMode = .add
    @State var selectedFruit = ""
    // オプショナル型を使用する場合、初期値はnilのため設定しなくてもOK
    @State var selectedIndex: Int?

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
                                selectedFruit = fruits[index].name
                                selectedIndex = index
                                isShowModal = true
                                modalMode = .edit
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
                        isShowModal = true
                        modalMode = .add
                    }
                    .fullScreenCover(isPresented: $isShowModal) {
                        ModalView(
                            onSave: {
                                fruits.append((name: $0, isSelected: false))
                            },
                            onUpdate: { newName in
                                // selectedIndexがオプショナル型であるためアンラップが必要。
                                if let index = selectedIndex {
                                    fruits[index].name = newName
                                }
                            },
                            modalMode: $modalMode,
                            name: selectedFruit
                        )
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

