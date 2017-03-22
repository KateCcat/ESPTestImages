//
//  Constants.h
//  ESPTestImages
//
//  Created by Kate on 22.03.17.
//  Copyright © 2017 Kate. All rights reserved.
//

#define kImageUrl @"http://devcandidates.alef.im/list.php"
#define kSizeIphone 2
#define kSizeIpad 3
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define WEAK_SELF_INIT __weak __typeof(self) weakself = self;
#define STRONG_SELF_INIT __strong __typeof(self) strongSelf = weakself;
