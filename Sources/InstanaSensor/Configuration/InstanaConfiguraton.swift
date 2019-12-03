//  Created by Nikola Lajic on 12/26/18.
//  Copyright © 2018 Nikola Lajic. All rights reserved.

import Foundation

struct InstanaConfiguration {
    enum Defaults {
        static let reportingURL: URL = URL(string: "http://localhost:3000")!
        static let remoteCallInstrumentationType = HTTPMonitor.ReportingType.automaticAndManual
        static let eventsBufferSize = 200
        static let suspendReporting = BeaconReporter.SuspendReporting.never
        static let sendDeviceLocationIfAvailable = false
        static let alertApplicationNotRespondingThreshold: Instana.Types.Seconds? = nil
        static let alertLowMemory = false
        static let alertFramerateDropThreshold: UInt? = nil
    }
    
    let reportingURL: URL
    let key: String
    let remoteCallInstrumentationType: HTTPMonitor.ReportingType
    let suspendReporting: BeaconReporter.SuspendReporting
    let eventsBufferSize: Int
    let sendDeviceLocationIfAvailable: Bool // TODO: implement
    let alertApplicationNotRespondingThreshold: Instana.Types.Seconds?
    let alertLowMemory: Bool
    let alertFramerateDropThreshold: UInt?
    
//    static func read(from path: String?) -> InstanaConfiguration? {
//        guard let path = path, let config = NSDictionary(contentsOfFile: path) else {
//            Instana.log.add("Couldn't locate configuration file")
//            return nil
//        }
//        return read(from: config)
//    }
    
//    private static func read(from dictionary: NSDictionary) -> InstanaConfiguration? {
//        guard let key = dictionary.value(forKey: "key") as? String else {
//            Instana.log.add("Value for \"key\" missing in configuration file")
//            return nil
//        }
//
//        return self.init(reportingURL: dictionary.value(forKey: "reportingURL") as? String ?? Defaults.reportingURL,
//                         key: key,
//                         remoteCallInstrumentationType: dictionary.fromRawValue(forKey: "remoteCallInstrumentationType") ?? Defaults.remoteCallInstrumentationType,
//                         suspendReporting: dictionary.fromRawValue(forKey: "suspendReporting") ?? Defaults.suspendReporting,
//                         eventsBufferSize: dictionary.value(forKey: "eventsBufferSize") as? Int ?? Defaults.eventsBufferSize,
//                         sendDeviceLocationIfAvailable: dictionary.bool(forKey: "sendDeviceLocationIfAvailable", fallback: Defaults.sendDeviceLocationIfAvailable),
//                         alertApplicationNotRespondingThreshold: dictionary.value(forKey: "alertApplicationNotRespondingThreshold") as? Instana.Types.Seconds ?? Defaults.alertApplicationNotRespondingThreshold,
//                         alertLowMemory: dictionary.bool(forKey: "alertLowMemory", fallback: Defaults.alertLowMemory),
//                         alertFramerateDropThreshold: dictionary.value(forKey: "alertFramerateDropThreshold") as? UInt ?? Defaults.alertFramerateDropThreshold)
//    }
    
    static func `default`(key: String, reportingURL: URL?) -> InstanaConfiguration {
        return self.init(reportingURL: reportingURL ?? Defaults.reportingURL,
                         key: key,
                         remoteCallInstrumentationType: Defaults.remoteCallInstrumentationType,
                         suspendReporting: Defaults.suspendReporting,
                         eventsBufferSize: Defaults.eventsBufferSize,
                         sendDeviceLocationIfAvailable: Defaults.sendDeviceLocationIfAvailable,
                         alertApplicationNotRespondingThreshold: Defaults.alertApplicationNotRespondingThreshold,
                         alertLowMemory: Defaults.alertLowMemory,
                         alertFramerateDropThreshold: Defaults.alertFramerateDropThreshold)
    }
}

private extension NSDictionary {
    func bool(forKey key: String, fallback: Bool) -> Bool {
        return value(forKey: key) as? Bool ?? fallback
    }
    
    func fromRawValue<T: RawRepresentable>(forKey key: String) -> T? {
        guard let raw = value(forKey: key) as? T.RawValue else { return nil }
        return T.init(rawValue: raw)
    }
}