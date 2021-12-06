//
//  QRCodeWidget.swift
//  QRCodeWidget
//
//  Created by Alireza on 12/6/21.
//

import WidgetKit
import SwiftUI
import Intents
import Alamofire
import Kingfisher

struct ModelEntry: TimelineEntry {
    var date: Date
    var widgetData: QR
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ModelEntry {
        return ModelEntry(date: Date(), widgetData: QR(data: "", success: false, error: nil, message: nil, title: nil))
    }
    
    public typealias Entry = ModelEntry

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let loadingModel = ModelEntry(date: Date(), widgetData: QR(data: "", success: false, error: nil, message: "nil", title: nil))
        completion(loadingModel)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        getQR { modelData in
            let date = Date()
            
            let data = ModelEntry(date: date, widgetData: modelData)
            
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: date) ?? Date()
            
            let timeLine = Timeline(entries: [data], policy: .after(nextUpdate))
            
            completion(timeLine)
        }
    }
}

// Widget UI
struct WidgetView: View {
    @Environment(\.widgetFamily) var family
    let model: ModelEntry
    
    var body: some View {
        switch family {
        case .systemSmall:
            if let data = model.widgetData.data,
               let url = URL(string: "https://sobarnes.com/wp-content/uploads/2021/06/ludmilla-makowski-copie-620x420.jpg") {
                KFImage.url(url)
                    .resizable()
            } else {
                Text(model.widgetData.message ?? "")
            }
        case .systemMedium:
            if let data = model.widgetData.data,
               let url = URL(string: "https://sobarnes.com/wp-content/uploads/2021/06/ludmilla-makowski-copie-620x420.jpg") {
                HStack {
                    KFImage.url(url)
                        .resizable()
                    Color.green
                        .cornerRadius(12)
                }
            } else {
                Text(model.widgetData.message ?? "")
            }
        default:
            Text("Some other WidgetFamily in the future.")
        }
    }
}

// Widget Configurations

@main
struct MainWidget: Widget {
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "QRCode-Widget", provider: Provider()) { data in
            WidgetView(model: data)
        }
        .description(Text("QR Code"))
        .configurationDisplayName(Text("QR Code"))
        .supportedFamilies([.systemMedium, .systemSmall])
    }
}

// Fetch Data
func getQR(completion: @escaping (QR) -> Void) {
    let url = "https://wsa2021.mad.hakta.pro/api/user_qr"
    let headders = HTTPHeaders([HTTPHeader(name: "Token", value: DataManager.shared.token)])
    
    AF.request(url, method: .get, headers: headders).responseDecodable(of: QR.self) { (response) in
        print(response.result)
        switch response.result {
        case .success(let model):
            DispatchQueue.main.async {
                completion(model)
            }
        case .failure(_):
            return
        }
    }
}
