//  Created by Nikola Lajic on 1/23/19.
//  Copyright © 2019 Nikola Lajic. All rights reserved.

import Foundation

class HTTPEvent: Event {
    let duration: Instana.Types.Milliseconds
    let method: String
    let url: String
    let path: String?
    let connectionType: NetworkMonitor.ConnectionType?
    let responseCode: Int
    let result: String
    let requestSize: Instana.Types.Bytes
    let responseSize: Instana.Types.Bytes
    
    init(timestamp: Instana.Types.Milliseconds,
         duration: Instana.Types.Milliseconds = Date().millisecondsSince1970,
         method: String,
         url: String,
         connectionType: NetworkMonitor.ConnectionType?,
         responseCode: Int = -1,
         requestSize: Instana.Types.Bytes = 0,
         responseSize: Instana.Types.Bytes = 0,
         result: String) {
        let path = URL(string: url)?.path ?? ""
        self.duration = duration
        self.method = method
        self.url = url
        self.path = !path.isEmpty ? path : nil
        self.connectionType = connectionType
        self.responseCode = responseCode
        self.requestSize = requestSize
        self.responseSize = responseSize
        self.result = result
        super.init(timestamp: timestamp)
    }
}