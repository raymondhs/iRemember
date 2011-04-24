//
//  StorageTest.h
//  iRemember
//
//  Created by Yingbo Zhan on 4/2/11.
//  Copyright 2011 NUS. All rights reserved.
//
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

//  Application unit tests contain unit test code that must be injected into an application to run correctly.
//  Define USE_APPLICATION_UNIT_TEST to 0 if the unit test code is designed to be linked into an independent test executable.


#import "IRWord.h"
#import "IRLibrary.h"
#import "IRHeader.h"
#import <UIKit/UIKit.h>
//#import	<CoreGraphics/CoreGraphics.h>
#import <SenTestingKit/SenTestingKit.h>
#import <Foundation/Foundation.h>
@interface StorageTest : SenTestCase 
{
	//IRWord List used for IRWord Test
	IRWord *word1;
	IRWord *word2;
	IRWord *word3;
	IRWord *word4;
	IRWord *word5;
	IRWord *word6;
	IRWord *word7;
	IRWord *word8;
	IRWord *word9;
	IRWord *word0;
	IRLibrary *englishLibrary;
	IRLibrary *chineseLibrary;
	IRLibrary *indonesLibrary;

	

}


@end
