# UHFileIO

[![CI Status](https://img.shields.io/travis/MacRong/UHFileIO.svg?style=flat)](https://travis-ci.org/MacRong/UHFileIO)
[![Version](https://img.shields.io/cocoapods/v/UHFileIO.svg?style=flat)](https://cocoapods.org/pods/UHFileIO)
[![License](https://img.shields.io/cocoapods/l/UHFileIO.svg?style=flat)](https://cocoapods.org/pods/UHFileIO)
[![Platform](https://img.shields.io/cocoapods/p/UHFileIO.svg?style=flat)](https://cocoapods.org/pods/UHFileIO)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

UHFileIO is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'UHFileIO'
```

## Example

```
// /Documents/UHVideo/MyDirectory
NSString *doucment = [UHFileIOManager.uh_pathdocumentsDirectory stringByAppendingPathComponent:@"MyDirectory"];
[UHFileIOManager createDirectoriesForPath:doucment error:nil];
    
// 删除文件
BOOL ld = [UHFileIOManager removeFilesInDirectoryAtPath:doucment error:nil];
    
```

## Author

MacRong, 121071838@qq.com

## License

UHFileIO is available under the MIT license. See the LICENSE file for more info.
