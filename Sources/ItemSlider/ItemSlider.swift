import SwiftUI

@available(iOS 14.0, *)
struct TestView: View {
    
    @State private var items: [DemoItem] = [
        DemoItem(title: "Title I", description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam"),
        DemoItem(title: "Title II", description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam"),
        DemoItem(title: "Title III", description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam")
    ]
    @State private var selectedItem: Int = 0
    
    var body: some View {
        
        ItemSlider(
            items: self.$items,
            selectedItem: self.$selectedItem,
            indexDotsPosition: .BottomTrailing,
            showIndexArrows: true,
            content: { element in
                Rectangle()
                    .foregroundColor(Color.blue)
                    .overlay(
                        Text(element.title)
                    )
            },
            detailContent: { element in
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text(element.title).bold()
                        Spacer()
                    }
                    
                    Text(element.description)
                    
                }.padding()
            }
        )
        
    }
    
}

private struct DemoItem: Identifiable {
    public let id: UUID = UUID()
    let title: String
    let description: String
}



@available(iOS 14.0, *)
public struct HorizontalItemSlider_Previews: PreviewProvider {

    public static var previews: some View {

//        NavigationView {
//            TestView()
//                .background(Color(#colorLiteral(red: 0.9494678378, green: 0.9481791854, blue: 0.9695548415, alpha: 1)))
//                .navigationBarTitleDisplayMode(.inline)
//        }
//
//        NavigationView {
//            TestView()
//                .background(Color(#colorLiteral(red: 0.1100086048, green: 0.1094449237, blue: 0.1180388853, alpha: 1)))
//                .navigationBarTitleDisplayMode(.inline)
//        }.colorScheme(ColorScheme.dark)
//
//        NavigationView {
//            List {
//                TestView()
//            }.listStyle(GroupedListStyle())
//            .navigationBarTitleDisplayMode(.inline)
//        }
        
        NavigationView {
            List {
                TestView()
            }.listStyle(GroupedListStyle())
            .navigationBarTitleDisplayMode(.inline)
        }.colorScheme(ColorScheme.dark)

    }

}

@available(iOS 14.0, *)
public extension ItemSlider where DetailContent == EmptyView {

    init(
        items: Binding<[Element]>,
        selectedItem: Binding<Int>,
        indexDotsPosition: IndexDotsPosition = IndexDotsPosition.None,
        showIndexArrows: Bool = false,
        contentHeight: CGFloat = 256,
        isListHeader: Bool = false,
        @ViewBuilder content: @escaping (_ element: Element) -> Content
    ) {
        self._items = items
        self._selectedItem = selectedItem
        self.indexDotsPosition = indexDotsPosition
        self.showIndexArrows = showIndexArrows
        self.contentHeight = contentHeight
        self.isListHeader = isListHeader
        self.content = content
        self.detailContent = { _ in EmptyView() }
    }

}

@available(iOS 14.0, *)
public struct ItemSlider<Element, Content: View, DetailContent: View>: View {
    
    public enum IndexDotsPosition {
        case None, TopLeading, TopCenter, TopTrailing, BottomLeading, BottomCenter, BottomTrailing
    }

    public init(
        items: Binding<[Element]>,
        selectedItem: Binding<Int>,
        indexDotsPosition: IndexDotsPosition = IndexDotsPosition.None,
        showIndexArrows: Bool = false,
        contentHeight: CGFloat = 256,
        @ViewBuilder content: @escaping (_ element: Element) -> Content,
        @ViewBuilder detailContent: @escaping (_ element: Element) -> DetailContent
    ) {
        self._items = items
        self._selectedItem = selectedItem
        self.indexDotsPosition = indexDotsPosition
        self.showIndexArrows = showIndexArrows
        self.contentHeight = contentHeight
        self.isListHeader = false
        self.content = content
        self.detailContent = detailContent
    }
    
    @Binding private var selectedItem: Int
    @Binding private var items: [Element]
    
    private let indexDotsPosition: IndexDotsPosition
    private let showIndexArrows: Bool
    private let contentHeight: CGFloat
    private let isListHeader: Bool
    
    public var content: (_ element: Element) -> Content
    public var detailContent: (_ element: Element) -> DetailContent
    
    public var body: some View {
        
        let c = VStack {
                
            ZStack {
                
                TabView(selection: self.$selectedItem) {
                    
                    ForEach(0..<self.items.count) { i in
                        self.content(self.items[i]).tag(i)
                    }
                    
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: PageTabViewStyle.IndexDisplayMode.never))
//                        Needs to be fixed: Vertical bouncing of content
//                        .onAppear(perform: {
//                            UIScrollView.appearance().bounces = false
//                        })
                
                if self.showIndexArrows && self.items.count > 1 {
                    
                    HStack {
                        Button(
                            action: { self.selectedItem = self.selectedItem == 0 ? self.items.count - 1 : self.selectedItem - 1 },
                            label: {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(Color.primary)
                                    .padding()
                            }
                        ).buttonStyle(BorderlessButtonStyle())
                        Spacer()
                        Button(
                            action: { self.selectedItem = self.selectedItem == self.items.count - 1 ? 0 : self.selectedItem + 1 },
                            label: {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.primary)
                                    .padding()
                            }
                        ).buttonStyle(BorderlessButtonStyle())
                    }
                    
                }
                
                if self.items.count > 1 && self.indexDotsPosition != IndexDotsPosition.None {
                    
                    HStack {
                        
                        if self.indexDotsPosition == .TopTrailing || self.indexDotsPosition == .BottomTrailing {
                            Spacer()
                        }
                        
                        VStack {
                            
                            if self.indexDotsPosition == .BottomLeading || self.indexDotsPosition == .BottomCenter || self.indexDotsPosition == .BottomTrailing {
                                Spacer()
                            }
                            
                            HStack(spacing: 10) {
                                ForEach(0..<self.items.count, id: \.self) { i in

                                    Circle()
                                        .frame(width: 8, height: 8)
                                        .foregroundColor((i == self.selectedItem) ? Color.primary : Color.gray.opacity(0.3))

                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 9)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(16)
                            
                            if self.indexDotsPosition == .TopLeading || self.indexDotsPosition == .TopCenter || self.indexDotsPosition == .TopTrailing {
                                Spacer()
                            }
                            
                        }
                        
                        if self.indexDotsPosition == .TopLeading || self.indexDotsPosition == .BottomLeading {
                            Spacer()
                        }
                        
                    }.padding(10)
                    
                }
                
            }.frame(height: self.contentHeight)
                
                
            self.detailContent(self.items[self.selectedItem])
            
        }
            
        
        
        if self.items.count > 0 {
            
            if self.isListHeader {
                
                Section(header: c.listRowInsets(EdgeInsets()).textCase(.none)) {}
                
            } else {
                
                Section {
                    c
                }.listRowInsets(EdgeInsets())
                
            }
            
        }

    }

}
