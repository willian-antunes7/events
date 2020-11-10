import Combine
import ComposableArchitecture
import SwiftUI

struct EventDetailsView: View {
    let store: Store<EventDetailsState, EventDetailsAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack() {
                    MapView(latitude: viewStore.latitude, longitude: viewStore.longitude)
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: UIScreen.main.bounds.height / 3)
                    CircleImage(image: viewStore.image)
                        .offset(x: 0, y: -122)
                        .padding(.bottom, -122)
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("$\(String(format: "%.2f", viewStore.price))")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.pink)
                            Text(viewStore.formattedDate)
                                .font(.system(size: 20, weight: .regular, design: .default))
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 16) {
                            Button(action: {
                                viewStore.send(.presentShareSheet)
                            }) {
                                Image(systemName: "square.and.arrow.up.fill")
                                    .foregroundColor(.pink)
                                    .font(.largeTitle)
                            }
                            Button(action: {
                                viewStore.send(.postCheckin)
                            }) {
                                Text("Check-in")
                                    .bold()
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 24)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, -48)
                    Divider()
                    LazyVStack(alignment: .leading) {
                        Text(viewStore.description)
                        Divider()
                        Text("Going")
                            .font(.headline)
                        List {
                            ForEach(viewStore.people) { person in
                                PersonRow(person: person)
                            }
                        }
                    }
                    .padding(16)
                    .alert(isPresented: viewStore.binding(get: \.alert, send: .dismissAlert)) {
                        return Alert(title: Text("Network failure"), message: Text(viewStore.alertText))
                    }
                    .sheet(isPresented: viewStore.binding(get: \.shareSheetIsPresented, send: .dismissShareSheet)) {
                        ShareSheet(activityItems: ["\(viewStore.title) \(viewStore.formattedDate)"])
                    }
                    Spacer()
                }.navigationTitle(viewStore.title)
            }.onAppear(perform: {
                viewStore.send(.fetchEventDetails)
            })
        }
    }
}

//struct EventDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventDetailsView()
//    }
//}
