//  Created by Nikola Lajic on 3/14/19.
//  Copyright © 2019 Nikola Lajic. All rights reserved.

import XCTest
@testable import iOSSensor

class InstanaSessionProfileEventTests: XCTestCase {

    func test_sessionProfileEventValues_shouldBeSerializedToJSON() {
        let event = InstanaSessionProfileEvent()
        compareDictionaries(original: event.toJSON(), expected: [
            "sessionId": ComparisonType.nonEmptyString,
            "id": ComparisonType.shouldBeNil,
            "profile": [
                "platform": "iOS",
                "osLevel": InstanaSystemUtils.systemVersion,
                "deviceType": InstanaSystemUtils.deviceModel,
                "appVersion": InstanaSystemUtils.applicationVersion,
                "appBuild": InstanaSystemUtils.applicationBuildNumber,
                "clientId": InstanaSystemUtils.clientId
            ]
        ])
    }
    
    func test_submissionFailure_shouldRetrySubmission() {
        var count = 0
        let exp = expectation(description: "Waiting for submission")
        let submitter: (InstanaEvent) -> Void = {
            count += 1
            guard let notifiable = $0 as? InstanaEventResultNotifiable else { XCTFail("Event not notifiable"); return }
            switch count {
            case 1:
                notifiable.completion(.failure(error: CocoaError(CocoaError.coderReadCorrupt)))
            case 2:
                notifiable.completion(.success)
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10)) {
                    exp.fulfill()
                }
            default:
                XCTFail("Retried too many times: \(count)")
            }
        }
        let event = InstanaSessionProfileEvent(retryInterval: 1, submitEvent: submitter)
        submitter(event)
        waitForExpectations(timeout: 0.05, handler: nil)
    }
}