# Salesforce Loyalty Mobile SDK for iOS

Salesforce Loyalty Mobile SDK gives developers the tools to build custom mobile apps with unique user experiences. Mobile SDK allows our
customers to produce standalone or integrate with existing Apps that they distribute through the App Store or Google Play Store. These apps
can target customers, business and partners.

Loyalty Mobile SDK enables programs to engage with members on mobile channels and deliver immersive experiences. As a Loyalty Program
Member, users can access a mobile app to view their membership details, avail promotions and vouchers, manage their loyalty rewards, and
engage with the brand.

LoyaltyMobileSDK-iOS is a Swift package that provides a convenient and easy-to-use interface for integrating loyalty program features into
your iOS applications. The SDK currently supports iOS 15+.

## Features

- Profile information
- Benefit information
- Enrollment
- Enroll and unenroll in promotions
- Promotions management
- Vouchers management
- Transaction history

## Installation

To integrate LoyaltyMobileSDK-iOS into your Xcode project, add it as a package dependency:

1. In Xcode, navigate to File > Swift Packages > Add Package Dependency.
2. Enter the repository URL: `https://github.com/salesforce-misc/LoyaltyMobileSDK-iOS`
3. Specify the version you want to use.

## Usage

First, import the `LoyaltyMobileSDK` module into your Swift file:

```swift
import LoyaltyMobileSDK
```

Then, you can use the SDK's APIs to manage loyalty features in your application.

## ForceSwift

ForceSwift is a set of tools that allows developers to interact with Salesforce through a third-party app. The library provides several structs and classes
to perform common Salesforce operations, such as authentication and making network requests.

### Key Components

1. `ForceAPI` - Provides a utility function to generate the path for API endpoints based on the API name and version.
2. `ForceAuthenticator` - A protocol defining the required methods for handling access tokens in Salesforce API.
3. `ForceClient` - A class handling network requests with authentication using `ForceAuthenticator`. It provides methods for fetching data from Salesforce API or a local JSON file.
4. `ForceRequest` - A struct to help create and configure `URLRequest` instances. It provides utility functions for creating requests with a URL, adding query parameters, and setting authorization.
5. `NetworkManagerProtocol` - A protocol that defines the requirements for a network manager.
6. `NetworkManager` - A class that handles network requests and data processing. It conforms to the `NetworkManagerProtocol` and provides a method to fetch data and decode it into the specified type.

## LoyaltyAPIManager

The `LoyaltyAPIManager` class manages requests related to loyalty programs using the Force API. It provides an easy way to interact with the Salesforce
Loyalty Management API and retrieve member benefits, member profiles, and other related data. It can be used in both development and production
environments.

### Features

- Handles authentication using a `ForceAuthenticator` instance
- Provides methods for interacting with the Loyalty Management API, including:
  - Get Member Benefits
  - Get Member Profile
  - Get Community Member Profile
  - Get Transaction History
  - Get Promotions
  - Enroll in Promotion
  - Unenroll from Promotion
  - Get Vouchers
- Supports both live API calls and local JSON file fetching for development mode
- Uses Swift async/await syntax for asynchronous requests

### Usage

1. Create an instance of `LoyaltyAPIManager` with the necessary parameters:

```swift
let loyaltyAPIManager = LoyaltyAPIManager(auth: forceAuthenticator, loyaltyProgramName: "YourLoyaltyProgramName", instanceURL: "YourInstanceURL", forceClient: forceClient)
```

2. Call the appropriate methods to interact with the Loyalty Management API:

```swift
import LoyaltyMobileSDK

let instanceURL = URL(string: "https://your_salesforce_instance_url")!
let loyaltyProgramName = "YourLoyaltyProgramName"
let forceClient = ForceClient(clientId: "your_client_id", clientSecret: "your_client_secret", redirectURI: "your_redirect_uri")

let loyaltyAPIManager = LoyaltyAPIManager(instanceURL: instanceURL, loyaltyProgramName: loyaltyProgramName, forceClient: forceClient)

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

// Get Member Benefits
let benefits = try await loyaltyAPIManager.getMemberBenefits(for: "memberId")

// Get Member Profile
let profile = try await loyaltyAPIManager.getMemberProfile(for: "memberId")

// Get Community Member Profile
let communityProfile = try await loyaltyAPIManager.getCommunityMemberProfile()


// Enroll a member in a promotion
try await loyaltyAPIManager.enrollIn(promotion: "PromotionName", for: "1234567890")

// Unenroll a member from a promotion using promotion ID or using promotion name
try await loyaltyAPIManager.unenroll(promotionId: "promotionId", for: "1234567890")
try await loyaltyAPIManager.unenroll(promotionName: "PromotionName", for: "1234567890")

// Get transactions for a loyalty member
let transactions = try await loyaltyAPIManager.getTransactions(for: "1234567890")

// Get promotions for a loyalty member
let promotions = try await loyaltyAPIManager.getPromotions(membershipNumber: "1234567890")

// Get vouchers for a loyalty member
let vouchers = try await loyaltyAPIManager.getVouchers(membershipNumber: "1234567890")

```

For a detailed understanding of each method and its parameters, please refer to the comments in the provided `LoyaltyAPIManager` code.

## Contributing

We welcome contributions to this project. To contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch with a descriptive name.
3. Implement your changes and ensure that tests are passing.
4. Create a pull request and describe your changes.

## License

LoyaltyMobileSDK-iOS is available under the BSD 3-Clause License.

Copyright (c) 2023, Salesforce Industries
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
