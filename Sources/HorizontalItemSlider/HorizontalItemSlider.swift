import SwiftUI

@available(iOS 14.0, *)
public struct HorizontalItemSlider<Element, Content: View>: View {

    @State private var selection: Int = 0

    public let showIndices: Bool

    public let verticalIndicesAlignment: VerticalAlignment
    public let horizontalIndicesAlignment: HorizontalAlignment

    public var array: [Element]
    public var content: (_ element: Element) -> Content

    public init(
        showIndices: Bool = true,
        verticalIndicesAlignment: VerticalAlignment = VerticalAlignment.bottom,
        horizontalIndicesAlignment: HorizontalAlignment = HorizontalAlignment.center,
        array: [Element],
        @ViewBuilder content: @escaping (_ element: Element) -> Content
        
    ) {
        self.showIndices = true
        self.verticalIndicesAlignment = verticalIndicesAlignment
        self.horizontalIndicesAlignment = horizontalIndicesAlignment
        self.array = array
        self.content = content
    }

    public var body: some View {

        ZStack {
            
            TabView(selection: self.$selection) {
                
                ForEach(0..<self.array.count) { i in
                    
                    self.content(self.array[i])
                        .tag(i)
                    
                }
                
            }.tabViewStyle(
                PageTabViewStyle(indexDisplayMode: PageTabViewStyle.IndexDisplayMode.never)
            )

            if self.array.count > 1 && self.showIndices {

                VStack {

                    if self.verticalIndicesAlignment == VerticalAlignment.bottom {
                        Spacer()
                    }

                    HStack {

                        if self.horizontalIndicesAlignment == HorizontalAlignment.trailing {
                            Spacer()
                        }

                        HStack(spacing: 10) {
                            ForEach(0..<self.array.count, id: \.self) { i in

                                Circle()
                                    .frame(width: 8, height: 8)
                                    .foregroundColor((i == self.selection) ? Color.primary : Color.gray.opacity(0.3))

                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 9)
                        .background(Color(UIColor.secondarySystemBackground))
                        .clipped()
                        .cornerRadius(16)

                        if self.horizontalIndicesAlignment == HorizontalAlignment.leading {
                            Spacer()
                        }

                    }

                    if self.verticalIndicesAlignment == VerticalAlignment.top {
                        Spacer()
                    }

                }.padding(8)

            }

        }

    }

}



@available(iOS 14.0, *)
public struct HorizontalItemSlider_Previews: PreviewProvider {

    public static var previews: some View {

        NavigationView {

            HorizontalItemSlider(
                horizontalIndicesAlignment: HorizontalAlignment.trailing,
                array: [
                    "Hallo", "Welt", "!"
                ]
            ) { element in
                
                Text("\(element)")
                    .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                    .background(Color.red)
                
            }.frame(height: 256)

        }.colorScheme(.dark)

    }

}
