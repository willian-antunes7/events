import Combine
import ComposableArchitecture
import SwiftUI

struct EventDetailsState: Equatable {
    var id: String
    var event: EventDetails?
    var imageData: Data?
    var alert: Bool = false
    var alertText: String = ""
    var shareSheetIsPresented: Bool = false
    
    var title: String {
        event?.title ?? ""
    }
    
    var description: String {
        event?.description ?? ""
    }
    
    var people: [Person] {
        event?.people ?? []
    }
    
    var latitude: Double {
        event?.latitude ?? 0
    }
    
    var longitude: Double {
        event?.longitude ?? 0
    }
    
    var price: Double {
        event?.price ?? 0
    }
    
    var formattedDate: String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(event?.date ?? 0)))
    }
    
    var image: Image {
        guard let data = imageData else {
            return Image(systemName: "camera.circle.fill")
        }
        guard let uiImage = UIImage(data: data) else {
            return Image(systemName: "camera.circle.fill")
        }
        return Image(uiImage: uiImage)
    }
}

enum EventDetailsAction {
    case fetchEventDetails
    case fetchEventDetailsResult(Result<EventDetails, RequestError>)
    case fetchImageData(Result<Data, RequestError>)
    case postCheckin
    case postCheckinResult(Result<[String:String], RequestError>)
    case dismissAlert
    case presentShareSheet
    case dismissShareSheet
}

struct EventDetailsEnvironment {
    var facade: EventFacadeProtocol
}

let eventDetailsReducer = Reducer<EventDetailsState, EventDetailsAction, EventDetailsEnvironment> { state, action, environment in
    switch action {
    case .fetchEventDetails:
        return environment.facade.getEventDetails(id: state.id)
            .catchToEffect()
            .map(EventDetailsAction.fetchEventDetailsResult)
    case let .fetchEventDetailsResult(result):
        switch result {
        case let .success(event):
            state.event = event
            return environment.facade.getImageData(url: event.image)
                .catchToEffect()
                .map(EventDetailsAction.fetchImageData)
        case let .failure(error):
            print(error)
        }
        return .none
    case let .fetchImageData(result):
        switch result {
        case let .success(data):
            state.imageData = data
        case let .failure(error):
            print(error)
        }
        return .none
    case .postCheckin:
        return environment.facade.postCheckin(eventId: state.id, name: "Willian", email: "willian.antunes@me.com")
            .catchToEffect()
            .map(EventDetailsAction.postCheckinResult)
    case let .postCheckinResult(result):
        switch result {
        case let .success(response):
            switch response["code"] {
            case "200":
                state.alert = true
                state.alertText = "Check-in Successful!"
            default:
                state.alert = true
                state.alertText = "Something went wrong!"
            }
        case let .failure(error):
            print(error)
        }
        return .none
    case .dismissAlert:
        state.alert = false
        return .none
    case .presentShareSheet:
        state.shareSheetIsPresented = true
        return .none
    case .dismissShareSheet:
        state.shareSheetIsPresented = false
        return .none
    }
}
