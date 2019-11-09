//
//  UIPlaceHolderTextView.h
//  KindWorker
//
//  Created by NaSalRyo on 21/10/2017.
//  Copyright © 2017 NaSalRyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
IB_DESIGNABLE

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) IBInspectable NSString *placeholder;
@property (nonatomic, retain) IBInspectable UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
