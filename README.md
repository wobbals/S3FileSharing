# S3FileSharing

Offers a simple interface for uploading and downloading files to AWS S3.
Additionally, offers a subclass of OTSession of the OpenTok iOS SDK that
supports simple file sharing between OpenTok clients.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Create a `Config.plist` (see example `Config.plist.sample`) to provide AWS
Cognito credentials based on the example app. See `OTAppDelegate.m` for an 
example to get started.

In the general case, you will need to set up a credentials
provider and service configuration at app launch, and make sure your user has
write access to the S3 bucket that the client will attempt to use to share
files. 

*IMPORTANT* : AWS S3 does a weird thing with multipart uploads against invalid
credentials. If your credentials are not legit, or have insufficient
permissions to read/write to the appropriate S3 bucket, uploads will not fail
but instead continue to retry until the request times out. This can be very
difficult to detect and I haven't yet figured out a workaround.


## Requirements

## Installation

S3FileSharing is not yet published to CocoaPods, awaiting peer review.

## Author

Charley Robinson, charley@tokbox.com

## License

S3FileSharing is available under the MIT license. See the LICENSE file for more info.
