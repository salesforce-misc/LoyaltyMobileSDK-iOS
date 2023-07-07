# Save Time and Effort With Loyalty Management Mobile SDK for iOS

Experience Loyalty Management on your iOS mobile devices and use the mobile software development kit’s (SDK) capabilities and build custom mobile applications with unique user experiences. Use pre-built loyalty components to build your own apps or enhance your existing mobile apps. Build the SDK for your loyalty program members to view their profile, membership details, and benefits, to enroll for promotions, and to avail vouchers. The SDK is bundled with a ready-to-use sample app, which is embedded with Loyalty Management features.

**Where:** This feature is available in Lightning Experience in all editions.  
**How:** Install the Loyalty Management Mobile SDK for iOS, create a connected app, and then clone the GitHub repository.

## iOS Mobile SDK for Loyalty Management

Enhance brand engagement by providing Loyalty Management features on your iOS mobile devices. Use the iOS Mobile Software Development Kit (SDK) for Loyalty Management to build custom mobile applications with immersive member experiences. Elevate member experience and loyalty, by providing personalized offers, rewards, and checkouts on mobile devices.

### Supported Versions of Tools and Components

| Tool or Component     | Supported Version | Installation Details          |
|-----------------------|-------------------|-------------------------------|
| Swift Version         | 5.7+              | Installed by Xcode            |
| Xcode                 | 14.0+             | Install from the App Store    |
| iOS SDK               | 15.0+             | Installed by Xcode            |
| Swift Package Manager | 5.7+              | Included in Swift             |

### Installation

To integrate Loyalty Management Mobile SDK for iOS with your Xcode project, add it as a package dependency.

1. With your app project open in Xcode, select **File** → **Swift Packages** → **Add Package Dependency**.
2. Enter the repository URL: `https://github.com/salesforce-misc/LoyaltyMobileSDK-iOS`
3. Select a version, and click **Add Package**.

## Import SDK in an iOS Swift Project

Automatically download and manage external dependencies. To import Loyalty Management Mobile SDK for iOS, open the swift file where you want to save LoyaltyMobileSDK, and to the first line of code, add:

```swift
import LoyaltyMobileSDK
```

## ForceSwift

ForceSwift is a library that uses SwiftUI to build user interfaces in iOS apps while interacting with Salesforce. ForceSwift provides tools, structures, classes, and utilities that make it easier to perform common operations, such as authentication and network requests. Key components of ForceSwift include:

- `ForceAPI` - A struct that generates the path for API endpoints, based on the API name and version.
- `ForceAuthenticator` - A  protocol that defines the required methods for handling access tokens in Salesforce API.
- `ForceClient` - A class that handles network requests with authentication by using `ForceAuthenticator`. This class provides methods to fetch data from Salesforce API or a local JSON file. 
- `ForceRequest` - A struct to help create and configure URLRequest instances. It provides utility functions to create requests with a URL, add query parameters, and set authorization.
- `NetworkManagerProtocol` - A protocol that defines the requirements for a network manager.
- `NetworkManager` - A class that handles network requests and data processing. This class conforms to the NetworkManagerProtocol and provides a method to fetch and decode the data into the specified type.

## LoyaltyAPIManager

The `LoyaltyAPIManager` class manages requests related to loyalty programs using the Force API. Interact with the Salesforce Loyalty Management API and retrieve member benefits, transactions, profile, and more, in development and production environments. With LoyaltyAPIManager, you can:
- Manage authentication by creating an instance of ForceAuthenticator.
- Interact with the Loyalty Management APIs, including:
    - Individual Member Enrollments
    - Enroll for Promotions
    - Get Member Promotions
    - Member Benefits
    - Member Profile
    - Member Vouchers
    - Transaction History
    - Opt Out from a Promotion
- Support both live API calls and local JSON file fetch for development mode.
- Manage asynchronous requests by using Swift Aync/Await syntax.

### Usage

1. In order to use the SDK, you need to provide a valid `accessToken` to interact with Salesforce API. To do this, you are required to conform and implement [`ForceAuthenticator`](https://github.com/salesforce-misc/LoyaltyMobileSDK-iOS/blob/main/Sources/LoyaltyMobileSDK/ForceSwift/ForceAuthenticator.swift) protocol which we provided in the SDK. For our sample app, we implemented this protocol in [`ForceAuthManager.swift`](https://github.com/salesforce-misc/LoyaltyMobileSDK-iOS/blob/main/SampleApps/MyNTORewards/MyNTORewards/ForceSwift%2BExtra/ForceAuthManager.swift).

2. Create an instance of `ForceClient` with the necessary parameters:

```swift
let authManager = ForceAuthManager.shared
let forceClient = ForceClient(auth: authManager)
```

3. Create an instance of `LoyaltyAPIManager` with the necessary parameters:

```swift
let loyaltyAPIManager = LoyaltyAPIManager(auth: authManager, loyaltyProgramName: "YourLoyaltyProgramName", instanceURL: "YourInstanceURL", forceClient: forceClient)
```

4. Call the appropriate methods to interact with the Loyalty Management API:

```swift
import LoyaltyMobileSDK

let instanceURL = URL(string: "https://your_salesforce_instance_url")!
let loyaltyProgramName = "YourLoyaltyProgramName"
let authManager = ForceAuthManager.shared
let forceClient = ForceClient(auth: authManager)

let loyaltyAPIManager = LoyaltyAPIManager(auth: authManager, loyaltyProgramName: loyaltyProgramName, instanceURL: instanceURL, forceClient: forceClient)

// Enroll Members
let membershipNumber = "1234567890"
let firstName = "John"
let lastName = "Doe"
let email = "john.doe@example.com"
let phone = "4157891234"
let emailNotification = true

let enrollmentOutput = try await loyaltyAPIManager.postEnrollment(
    membershipNumber: membershipNumber,
    firstName: firstName,
    lastName: lastName,
    email: email,
    phone: phone,
    emailNotification: emailNotification
)

// Retrieve the member benefits
let benefits = try await loyaltyAPIManager.getMemberBenefits(for: "memberId")

// Retrieve the member profile
let profile = try await loyaltyAPIManager.getMemberProfile(for: "memberId")

// Retrive the community member profile
let communityProfile = try await loyaltyAPIManager.getCommunityMemberProfile()

// Opt in a promotion for member
try await loyaltyAPIManager.enrollIn(promotion: "PromotionName", for: "1234567890")

// Opt out a member from a promotion using promotion ID or promotion name
try await loyaltyAPIManager.unenroll(promotionId: "promotionId", for: "1234567890")
try await loyaltyAPIManager.unenroll(promotionName: "PromotionName", for: "1234567890")

// Retrieve loyalty member transactions
let transactions = try await loyaltyAPIManager.getTransactions(for: "1234567890")

// Retrieve promotions for a loyalty member
let promotions = try await loyaltyAPIManager.getPromotions(membershipNumber: "1234567890")

// Retrieve vouchers for a loyalty member
let vouchers = try await loyaltyAPIManager.getVouchers(membershipNumber: "1234567890")

```

For a detailed understanding of each method and its parameters, please refer to the comments in the provided `LoyaltyAPIManager` code.

## Test the Loyalty Management Mobile SDK for iOS and Sample App

Run the `run_tests.sh` script from the command line to test the LoyaltyMobileSDK-iOS and the sample app. To ensure that the script is executable, run the `chmod +x run_tests.sh` script. The script provides these capabilities.
- Verifies if `xcpretty` is installed, which is a formatter for xcodebuild and makes the output more readable. If not installed, install `xcpretty` by using the code `gem install xcpretty`.
- Determines the tests to run and whether the tests save the logs and reports.
Runs tests for the specified schemes and test targets. Also provides options to customize the test run. To customize the `run_tests.sh` script, choose from these options:
    - `-full`: Run all tests for the SDK and the sample app.
    - `-sdkOnly`: Run only the SDK tests.
    - `-appOnly`: Run only the sample app tests.
    - `-log`: Save the test output to a log file in the `build/TestRun_TIMESTAMP` directory.
    - `-report`: Save test reports as HTML files in the `build/TestRun_TIMESTAMP` directory.

### Examples

- Run SDK tests only:

  ```bash
  ./run_tests.sh
  ```

- Run all tests and save logs and reports:

  ```bash
  ./run_tests.sh -full -log -report
  ```

- Run sample app tests and save logs:

  ```bash
  ./run_tests.sh -appOnly -log
  ```

## Contribute to the SDK

You can contribute to the development of the Loyalty Management Mobile SDK. 
1. Fork the Loyalty Management Mobile SDK for iOS [repository](https://github.com/salesforce-misc/LoyaltyMobileSDK-iOS).
2. Create a branch with a descriptive name.
3. Implement your changes.
4. Test your changes.
5. Submit a pull request.

See also:
[Fork a repo](https://docs.github.com/en/get-started/quickstart/fork-a-repo)

## License

LoyaltyMobileSDK-iOS is available under the BSD 3-Clause License.

Copyright (c) 2023, Salesforce Industries
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
