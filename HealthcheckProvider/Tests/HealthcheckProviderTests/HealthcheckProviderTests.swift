@testable import Vapor
import Testing
import XCTest
@testable import HealthcheckProvider

class HealthcheckProviderTests: XCTestCase {
    func testHealthcheck() {
        var config = try! Config(arguments: ["vapor", "--env=test"])
        try! config.set("healthcheck.url", "healthcheck")
        try! config.addProvider(HealthcheckProvider.Provider.self)
        let drop = try! Droplet(config)
        background {
            try! drop.run()
        }
        
        try! drop
            .testResponse(to: .get, at: "healthcheck")
            .assertStatus(is: .ok)
            .assertJSON("status", equals: "up")
    }
    
    override func setUp() {
        Testing.onFail = XCTFail
    }
    static var allTests = [
        ("testHealthcheck", testHealthcheck),
        ]
}
