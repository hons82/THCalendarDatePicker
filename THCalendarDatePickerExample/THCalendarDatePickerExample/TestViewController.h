//
//  TestViewController.h
//  THCalendarDatePickerExample
//
//  Created by Hannes Tribus on 31/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THDatePickerViewController.h"

@interface TestViewController : UIViewController<THDatePickerDelegate>
- (IBAction)touchedButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (nonatomic, strong) THDatePickerViewController * datePicker;

@end
