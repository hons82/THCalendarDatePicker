//
//  THDatePickerViewController.m
//  THCalendarDatePicker
//
//  Created by chase wasden on 2/10/13.
//  Adapted by Hannes Tribus on 31/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "THDatePickerViewController.h"
#import "NSDate+Difference.h"

#ifdef DEBUG
//static int FIRST_WEEKDAY = 2;
#endif

@interface THDatePickerViewController () {
    int _weeksOnCalendar;
    int _bufferDaysBeginning;
    int _daysInMonth;
    NSDate * _dateNoTime;
    NSCalendar * _calendar;
    BOOL _allowClearDate;
    BOOL _allowSelectionOfSelectedDate;
    BOOL _clearAsToday;
    BOOL _autoCloseOnSelectDate;
    NSUInteger _daysInHistory;
    NSUInteger _daysInFuture;
    BOOL _disableYearSwitch;
    BOOL (^_dateHasItemsCallback)(NSDate *);
    float _slideAnimationDuration;
    NSMutableArray * _selectedDates;
    NSMutableArray * _selectedDateViews;
    BOOL _allowMultiDaySelection;
}
@property (nonatomic, strong) NSDate * firstOfCurrentMonth;
@property (nonatomic, strong) THDateDay * currentDay;
@property (nonatomic, strong) NSDate * internalDate;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextMonthBtn;
@property (weak, nonatomic) IBOutlet UIButton *prevMonthBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextYearBtn;
@property (weak, nonatomic) IBOutlet UIButton *prevYearBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *calendarDaysView;
@property (weak, nonatomic) IBOutlet UIView *weekdaysView;

- (IBAction)nextMonthPressed:(id)sender;
- (IBAction)prevMonthPressed:(id)sender;
- (IBAction)nextYearPressed:(id)sender;
- (IBAction)prevYearPressed:(id)sender;
- (IBAction)okPressed:(id)sender;
- (IBAction)clearPressed:(id)sender;
- (IBAction)closePressed:(id)sender;

- (void)redraw;

@end

@implementation THDatePickerViewController
@synthesize date = _date;
@synthesize selectedBackgroundColor = _selectedBackgroundColor;
@synthesize currentDateColor = _currentDateColor;
@synthesize currentDateColorSelected = _currentDateColorSelected;
@synthesize autoCloseCancelDelay = _autoCloseCancelDelay;
@synthesize dateTimeZone = _dateTimeZone;
@synthesize rounded = _rounded;
@synthesize historyFutureBasedOnInternal = _historyFutureBasedOnInternal;
@synthesize slideAnimationDuration = _slideAnimationDuration;
@synthesize selectedDates = _selectedDates;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _allowClearDate = NO;
        _allowSelectionOfSelectedDate = NO;
        _clearAsToday = NO;
        _daysInFuture = NO;
        _daysInHistory = NO;
        _historyFutureBasedOnInternal = NO;
        _autoCloseCancelDelay = 1.0;
        _dateTimeZone = [NSTimeZone defaultTimeZone];
        _slideAnimationDuration = .5;
        _selectedDates = [[NSMutableArray alloc] init];
        _selectedDateViews = [[NSMutableArray alloc] init];
        _allowMultiDaySelection = NO;
    }
    return self;
}

+(THDatePickerViewController *)datePicker {
    return [[THDatePickerViewController alloc] initWithNibName:@"THDatePickerViewController" bundle:[NSBundle bundleForClass:self.class]];
}

-(void)setAllowMultiDaySelection:(BOOL)allow {
    _allowMultiDaySelection = allow;
    if (_allowMultiDaySelection)
        [self setAutoCloseOnSelectDate:!allow]; // Caution possible endless loop
}

- (void)setAllowClearDate:(BOOL)allow {
    _allowClearDate = allow;
}

- (void)setAllowSelectionOfSelectedDate:(BOOL)allow {
    _allowSelectionOfSelectedDate = allow;
}

- (void)setClearAsToday:(BOOL)beTodayButton {
    if (beTodayButton) {
        [self setAllowClearDate:beTodayButton];
    }
    _clearAsToday = beTodayButton;
}

- (void)setAutoCloseOnSelectDate:(BOOL)autoClose {
    if (!_allowClearDate)
        [self setAllowClearDate:!autoClose];
    _autoCloseOnSelectDate = autoClose;
    if (_autoCloseOnSelectDate)
        _allowMultiDaySelection = NO;
}

- (void)setDisableHistorySelection:(BOOL)disableHistorySelection {
    _daysInHistory = disableHistorySelection;
}

- (void)setDisableFutureSelection:(BOOL)disableFutureSelection {
    _daysInFuture = disableFutureSelection;
}

- (void)setDaysInHistorySelection:(NSUInteger)daysInHistory {
    _daysInHistory = daysInHistory;
}

- (void)setDaysInFutureSelection:(NSUInteger)daysInFuture {
    _daysInFuture = daysInFuture;
}

- (void)setDateRangeFrom:(NSDate *)fromDate toDate:(NSDate *)toDate {
    if (!self.internalDate)
        return;
    
    NSDate *intFromDate = [(fromDate ? fromDate : self.internalDate) dateWithOutTime];
    NSDate *intToDate = [(toDate ? toDate : self.internalDate) dateWithOutTime];
    [self setDaysInHistorySelection:[[self.internalDate dateWithOutTime] daysFromDate:intFromDate]];
    [self setDaysInFutureSelection:[intToDate daysFromDate:[self.internalDate dateWithOutTime]]];
    
    [self setHistoryFutureBasedOnInternal:YES];
}

- (void)setDisableYearSwitch:(BOOL)disableYearSwitch {
    _disableYearSwitch = disableYearSwitch;
}

#pragma mark - View Management

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(semiModalDidHide:)
                                                 name:kSemiModalDidHideNotification
                                               object:nil];
    
    self.titleLabel.hidden = YES;
    
    [self configureButtonAppearances];
    if(_allowClearDate)
        [self showClearButton];
    else
        [self hideClearButton];
    [self addSwipeGestures];
    self.okBtn.enabled = [self shouldOkBeEnabled];
    [self.okBtn setImage:(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") ? [UIImage imageNamed:(_autoCloseOnSelectDate ? @"dialog_clear" : @"dialog_ok") inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] : [UIImage imageNamed:(_autoCloseOnSelectDate ? @"dialog_clear" : @"dialog_ok")]) forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self redraw];
}

- (void)addSwipeGestureRecognizerWithDirection:(UISwipeGestureRecognizerDirection)direction {
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.direction = direction;
    [self.calendarDaysView addGestureRecognizer:swipeGesture];
}

- (void)addSwipeGestures {
    if (!_disableYearSwitch) {
        [self addSwipeGestureRecognizerWithDirection:UISwipeGestureRecognizerDirectionUp];
        [self addSwipeGestureRecognizerWithDirection:UISwipeGestureRecognizerDirectionDown];
    }
    [self addSwipeGestureRecognizerWithDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addSwipeGestureRecognizerWithDirection:UISwipeGestureRecognizerDirectionRight];
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)sender{
    //Gesture detect - swipe up/down , can be recognized direction
    if(sender.direction == UISwipeGestureRecognizerDirectionUp){
        [self nextMonthPressed:sender];
    } else if(sender.direction == UISwipeGestureRecognizerDirectionDown){
        [self prevMonthPressed:sender];
    } else if(sender.direction == UISwipeGestureRecognizerDirectionRight){
        [self prevYearPressed:sender];
    } else {
        [self nextYearPressed:sender];
    }
}

- (void)configureButtonAppearances {
    [super viewDidLoad];
    [[self.nextMonthBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.prevMonthBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.nextYearBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.prevYearBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.clearBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.closeBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.okBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    UIImage * img = [self imageOfColor:[UIColor colorWithWhite:.8 alpha:1]];
    [self.clearBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    [self.closeBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    [self.okBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    
    img = [self imageOfColor:[UIColor colorWithWhite:.94 alpha:1]];
    [self.nextMonthBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    [self.prevMonthBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    [self.nextYearBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    [self.prevYearBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    
    // Hide Buttons if not active
    [self.nextMonthBtn setHidden:_disableYearSwitch];
    [self.prevMonthBtn setHidden:_disableYearSwitch];
}

- (UIImage *)imageOfColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)setDateHasItemsCallback:(BOOL (^)(NSDate * date))callback {
    _dateHasItemsCallback = callback;
}

#pragma mark - Callbacks

- (void)semiModalDidHide:(NSNotification *)notification {
    if ([self.delegate respondsToSelector:@selector(datePickerDidHide:)]) {
        [self.delegate datePickerDidHide:self];
    }
}

#pragma mark - Redraw Dates

- (void)redraw {
    if(!self.firstOfCurrentMonth) [self setDisplayedMonthFromDate:[NSDate date]];
    for(UIView * view in self.calendarDaysView.subviews){ // clean view
        [view removeFromSuperview];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
    [formatter setDateFormat:(_disableYearSwitch ? @"MMMM yyyy" : @"yyyy\nMMMM")];
    formatter.locale=[NSLocale currentLocale];
    NSString *monthName = [formatter stringFromDate:self.firstOfCurrentMonth];
    self.monthLabel.text = monthName;
    
    if (self.dateTitle != nil && _allowClearDate == NO) {
        self.titleLabel.text = self.dateTitle;
        self.titleLabel.hidden = NO;
    }
    
    [self redrawDays];
}

- (void)redrawDays {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:-_bufferDaysBeginning];
    NSDate * date = [_calendar dateByAddingComponents:offsetComponents toDate:self.firstOfCurrentMonth options:0];
    [offsetComponents setDay:1];
    UIView * container = self.calendarDaysView;
    CGRect containerFrame = container.frame;
    int areaWidth = containerFrame.size.width;
    int areaHeight = containerFrame.size.height;
    int cellWidth = areaWidth/7;
    int cellHeight = areaHeight/_weeksOnCalendar;
    int days = _weeksOnCalendar*7;
    int curY = (areaHeight - cellHeight*_weeksOnCalendar)/2;
    int origX = (areaWidth - cellWidth*7)/2;
    int curX = origX;
    [self redrawWeekdays:cellWidth];
    for(int i = 0; i < days; i++){
        // @beginning
        if(i && !(i%7)) {
            curX = origX;
            curY += cellHeight;
        }
        
        THDateDay * day = [[[NSBundle bundleForClass:self.class] loadNibNamed:@"THDateDay" owner:self options:nil] objectAtIndex:0];
        if ([self isRounded]) {
            [day setRounded:YES];
        }
        day.frame = CGRectMake(curX, curY, cellWidth, cellHeight);
        day.delegate = self;
        day.date = [date dateByAddingTimeInterval:0];
        if (self.currentDateColor)
            [day setCurrentDateColor:self.currentDateColor];
        if (self.currentDateColorSelected)
            [day setCurrentDateColorSelected:self.currentDateColorSelected];
        if (self.selectedBackgroundColor)
            [day setSelectedBackgroundColor:self.selectedBackgroundColor];
        
        if(!_allowMultiDaySelection) {
            if (_internalDate && ![[self dateWithOutTime:date] timeIntervalSinceDate:_internalDate]) {
                self.currentDay = day;
                [day setSelected:YES];
            }
        } else {
            if ([_selectedDates containsObject:date]) {
                if ([_selectedDates lastObject] == date) {
                    _internalDate = date;
                }
                [day setSelected:YES];
            } else {
                [day setSelected:NO];
            }
        }
        
        [day setLightText:![self dateInCurrentMonth:date]];
        [day setEnabled:![self dateInFutureAndShouldBeDisabled:date]];
        [day indicateDayHasItems:(_dateHasItemsCallback && _dateHasItemsCallback(date))];
        
        NSDateComponents *comps = [_calendar components:NSCalendarUnitDay fromDate:date];
        [day.dateButton setTitle:[NSString stringWithFormat:@"%ld",(long)[comps day]]
                        forState:UIControlStateNormal];
        [self.calendarDaysView addSubview:day];
        // @end
        date = [_calendar dateByAddingComponents:offsetComponents toDate:date options:0];
        curX += cellWidth;
    }
}

- (void)redrawWeekdays:(int)dayWidth {
    if(!self.weekdaysView.subviews.count) {
        CGSize fullSize = self.weekdaysView.frame.size;
        int curX = (fullSize.width - 7*dayWidth)/2;
        NSDateComponents * comps = [_calendar components:NSCalendarUnitDay fromDate:[NSDate date]];
        NSCalendar *c = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        [comps setDay:[c firstWeekday]-1];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setDay:1];
        [df setDateFormat:@"EE"];
        df.locale = [NSLocale currentLocale];
        [df setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
        NSDate * date = [_calendar dateFromComponents:comps];
        for(int i = 0; i < 7; i++){
            UILabel * dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(curX, 0, dayWidth, fullSize.height)];
            dayLabel.textAlignment = NSTextAlignmentCenter;
            dayLabel.font = [UIFont systemFontOfSize:12];
            [self.weekdaysView addSubview:dayLabel];
            dayLabel.text = [df stringFromDate:date];
            dayLabel.textColor = [UIColor grayColor];
            date = [_calendar dateByAddingComponents:offsetComponents toDate:date options:0];
            curX+=dayWidth;
        }
    }
}

#pragma mark - Date Set, etc.

- (NSArray *)selectedDates {
    return [[NSArray alloc] initWithArray:_selectedDates];
}

- (void)setSelectedDates:(NSArray *)selectedDates {
    
    _selectedDates = [[NSMutableArray alloc] init];
    for (NSDate* selectedDate in selectedDates) {
        [_selectedDates addObject:[self dateWithOutTime:selectedDate]];
    }
    if ([_selectedDates count] > 0) {
        _date = (NSDate*)[_selectedDates objectAtIndex:0];
        _dateNoTime = !_date ? nil : [self dateWithOutTime:_date];
        self.internalDate = [_dateNoTime dateByAddingTimeInterval:0];
    }
    [self redrawDays];
}

- (void)setDate:(NSDate *)date {
    [self setSelectedDates:@[date]];
}

- (NSDate *)date {
    if(!self.internalDate)
        return nil;
    else if(!_date)
        return self.internalDate;
    else {
        int ymd = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
        NSDateComponents* internalComps = [_calendar components:ymd fromDate:self.internalDate];
        int time = NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitTimeZone;
        NSDateComponents* origComps = [_calendar components:time fromDate:(_allowMultiDaySelection && [_selectedDates count] > 0 ? [_selectedDates lastObject] : _date)];
        [origComps setDay:[internalComps day]];
        [origComps setMonth:[internalComps month]];
        [origComps setYear:[internalComps year]];
        return [_calendar dateFromComponents:origComps];
    }
}

- (BOOL)shouldOkBeEnabled {
    if (!_allowMultiDaySelection) {
        if (_autoCloseOnSelectDate)
            return YES;
        NSLog(@"interval %f",[self.internalDate timeIntervalSinceDate:_dateNoTime]);
        return (self.internalDate && _dateNoTime && (_allowSelectionOfSelectedDate || [self.internalDate timeIntervalSinceDate:_dateNoTime]))
        || (self.internalDate && !_dateNoTime)
        || (!self.internalDate && _dateNoTime);
    } else {
        return ([_selectedDates count] > 0);
    }
}

- (void)setInternalDate:(NSDate *)internalDate{
    _internalDate = internalDate;
    self.clearBtn.enabled = internalDate;
    self.okBtn.enabled = [self shouldOkBeEnabled];
    if(internalDate){
        [self setDisplayedMonthFromDate:internalDate];
    } else {
        [self.currentDay setSelected:NO];
        self.currentDay =  nil;
    }
}

- (void)setDisplayedMonth:(int)month year:(int)year{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM"];
    [df setTimeZone:self.dateTimeZone];
    [df setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
    self.firstOfCurrentMonth = [df dateFromString: [NSString stringWithFormat:@"%d-%@%d", year, (month<10?@"0":@""), month]];
    [self storeDateInformation];
}

- (void)setDisplayedMonthFromDate:(NSDate *)date{
    NSDateComponents* comps = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    [self setDisplayedMonth:(int)[comps month] year:(int)[comps year]];
}

- (void)storeDateInformation{
    NSDateComponents *comps = [_calendar components:NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:self.firstOfCurrentMonth];
    NSCalendar *c = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
#ifdef DEBUG
    //[c setFirstWeekday:FIRST_WEEKDAY];
#endif
    NSRange days = [c rangeOfUnit:NSCalendarUnitDay
                           inUnit:NSCalendarUnitMonth
                          forDate:self.firstOfCurrentMonth];
    
    int bufferDaysBeginning = (int)([comps weekday]-[c firstWeekday]);
    // % 7 is not working for negative numbers
    // http://stackoverflow.com/questions/989943/weird-objective-c-mod-behavior-for-negative-numbers
    if (bufferDaysBeginning < 0)
        bufferDaysBeginning += 7;
    int daysInMonthWithBuffer = (int)(days.length + bufferDaysBeginning);
    int numberOfWeeks = daysInMonthWithBuffer / 7;
    if(daysInMonthWithBuffer % 7) numberOfWeeks++;
    
    _weeksOnCalendar = 6;
    _bufferDaysBeginning = bufferDaysBeginning;
    _daysInMonth = (int)days.length;
}

- (void)incrementMonth:(int)incrValue{
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:incrValue];
    NSDate * incrementedMonth = [_calendar dateByAddingComponents:offsetComponents toDate:self.firstOfCurrentMonth options:0];
    [self setDisplayedMonthFromDate:incrementedMonth];
}

- (BOOL)setDateTimeZoneWithName:(NSString *)name {
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:name];
    if (timeZone) {
        [self setDateTimeZone:timeZone];
        return YES;
    }
    return NO;
}

#pragma mark - User Events

- (void)dateDayTapped:(THDateDay *)dateDay {
    BOOL dateInDifferentMonth = ![self dateInCurrentMonth:dateDay.date];
    NSDate *firstOfCurrentMonth = self.firstOfCurrentMonth;
    if (!_allowMultiDaySelection) {
        if (!_internalDate || [_internalDate timeIntervalSinceDate:dateDay.date] || _allowSelectionOfSelectedDate) { // new date selected
            [self.currentDay setSelected:NO];
            [self.currentDay setLightText:![self dateInCurrentMonth:self.currentDay.date]];
            [dateDay setSelected:YES];
            [self setInternalDate:dateDay.date];
            [self setCurrentDay:dateDay];
            [_selectedDates removeAllObjects];
            [_selectedDates addObject:[self dateWithOutTime:dateDay.date]];
            if ([self.delegate respondsToSelector:@selector(datePicker:selectedDate:)]) {
                [self.delegate datePicker:self selectedDate:dateDay.date];
            }
        }
    } else {
        [self setInternalDate:dateDay.date];
        if (![_selectedDates containsObject:[self dateWithOutTime:dateDay.date]]){
            [_selectedDates addObject:[self dateWithOutTime:dateDay.date]];
            [dateDay setSelected:YES];
            if ([self.delegate respondsToSelector:@selector(datePicker:selectedDate:)]) {
                [self.delegate datePicker:self selectedDate:dateDay.date];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(datePicker:deselectedDate:)]) {
                [self.delegate datePicker:self deselectedDate:dateDay.date];
            }
            [dateDay setLightText:dateInDifferentMonth];
            [dateDay setSelected:NO];
            [_selectedDates removeObject:dateDay.date];
        }
        self.okBtn.enabled = [self shouldOkBeEnabled];
    }
    if (_autoCloseOnSelectDate) {
        [self.delegate datePickerDonePressed:self];
    }
    if (dateInDifferentMonth) {
        [self slideTransitionViewInDirection:[dateDay.date timeIntervalSinceDate:firstOfCurrentMonth]<0 ? UISwipeGestureRecognizerDirectionRight : UISwipeGestureRecognizerDirectionLeft];
    }
}

- (void)slideTransitionViewInDirection:(UISwipeGestureRecognizerDirection)dir {
    CGRect origFrame = self.calendarDaysView.frame;
    CGRect outDestFrame = origFrame;
    CGRect inStartFrame = origFrame;
    switch (dir) {
        case UISwipeGestureRecognizerDirectionUp:
            //outDestFrame.origin.y -= self.calendarDaysView.frame.size.height;
            inStartFrame.origin.y += self.calendarDaysView.frame.size.height;
            break;
        case UISwipeGestureRecognizerDirectionDown:
            outDestFrame.origin.y += self.calendarDaysView.frame.size.height;
            //inStartFrame.origin.y -= self.calendarDaysView.frame.size.height;
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            outDestFrame.origin.x -= self.calendarDaysView.frame.size.width;
            inStartFrame.origin.x += self.calendarDaysView.frame.size.width;
            break;
        default:
            outDestFrame.origin.x += self.calendarDaysView.frame.size.width;
            inStartFrame.origin.x -= self.calendarDaysView.frame.size.width;
            break;
    }
    UIView *oldView = self.calendarDaysView;
    UIView *newView = self.calendarDaysView = [[UIView alloc] initWithFrame:inStartFrame];
    [oldView.superview addSubview:newView];
    [self addSwipeGestures];
    newView.alpha = 0;
    [self redraw];
    [oldView.superview layoutSubviews];
    [UIView animateWithDuration:self.slideAnimationDuration animations:^{
        newView.frame = origFrame;
        newView.alpha = 1;
        oldView.frame = outDestFrame;
        oldView.alpha = 0;
    } completion:^(BOOL finished) {
        [oldView removeFromSuperview];
    }];
}

/* If _disableYearSwitch is true, then only the month switches are active, and they'll swipe left and right only */

- (IBAction)nextMonthPressed:(id)sender {
    [self incrementMonth:1];
    [self slideTransitionViewInDirection:(_disableYearSwitch ? UISwipeGestureRecognizerDirectionLeft : UISwipeGestureRecognizerDirectionUp)];
}

- (IBAction)prevMonthPressed:(id)sender {
    [self incrementMonth:-1];
    [self slideTransitionViewInDirection:(_disableYearSwitch ? UISwipeGestureRecognizerDirectionRight : UISwipeGestureRecognizerDirectionDown)];
}

- (IBAction)nextYearPressed:(id)sender {
    [self incrementMonth:(_disableYearSwitch ? 1 : 12)];
    [self slideTransitionViewInDirection:UISwipeGestureRecognizerDirectionLeft];
}

- (IBAction)prevYearPressed:(id)sender {
    [self incrementMonth:(_disableYearSwitch ? -1 : -12)];
    [self slideTransitionViewInDirection:UISwipeGestureRecognizerDirectionRight];
}

- (IBAction)okPressed:(id)sender {
    if(self.okBtn.enabled) {
        [self.delegate datePickerDonePressed:self];
    }
}

- (IBAction)clearPressed:(id)sender {
    if(self.clearBtn.enabled){
        if (_clearAsToday) {
            [self setDate:[NSDate date]];
            [self redraw];
            if (_autoCloseOnSelectDate) {
                [self.okBtn setUserInteractionEnabled:NO];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.autoCloseCancelDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.delegate datePickerDonePressed:self];
                    [self.okBtn setUserInteractionEnabled:YES];
                });
            }
        } else {
            self.internalDate = nil;
            [self.currentDay setSelected:NO];
            self.currentDay = nil;
        }
    }
}

- (IBAction)closePressed:(id)sender {
    [self.delegate datePickerCancelPressed:self];
}

#pragma mark - Hide/Show Clear Button

- (void) showClearButton {
    int width = self.view.frame.size.width;
    int buttonHeight = 37;
    int buttonWidth = (width-20)/3;
    int curX = (width - buttonWidth*3 - 10)/2;
    self.closeBtn.frame = CGRectMake(curX, 5, buttonWidth, buttonHeight);
    curX+=buttonWidth+5;
    self.clearBtn.frame = CGRectMake(curX, 5, buttonWidth, buttonHeight);
    curX+=buttonWidth+5;
    self.okBtn.frame = CGRectMake(curX, 5, buttonWidth, buttonHeight);
    if (_clearAsToday) {
        [self.clearBtn setImage:nil forState:UIControlStateNormal];
        [self.clearBtn setTitle:NSLocalizedString(@"TODAY", @"Customize this for your language") forState:UIControlStateNormal];
    } else {
        [self.clearBtn setImage:(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") ? [UIImage imageNamed:@"dialog_clear" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] : [UIImage imageNamed:@"dialog_clear"]) forState:UIControlStateNormal];
    }
}

- (void) hideClearButton {
    int width = self.view.frame.size.width;
    int buttonHeight = 37;
    self.clearBtn.hidden = YES;
    int buttonWidth = (width-15)/2;
    int curX = (width - buttonWidth*2 - 5)/2;
    self.closeBtn.frame = CGRectMake(curX, 5, buttonWidth, buttonHeight);
    curX+=buttonWidth+5;
    self.okBtn.frame = CGRectMake(curX, 5, buttonWidth, buttonHeight);
}

#pragma mark - Date Utils

- (BOOL)dateInFutureAndShouldBeDisabled:(NSDate *)dateToCompare {
    NSDate *currentDate = [(self.isHistoryFutureBasedOnInternal ?
                            self.internalDate : [NSDate date]) dateWithOutTime];
    NSInteger dayDifference = [currentDate daysFromDate:dateToCompare];
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSInteger comps = (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear);
    currentDate = [calendar dateFromComponents:[calendar components:comps fromDate:currentDate]];
    dateToCompare = [calendar dateFromComponents:[calendar components:comps fromDate:dateToCompare]];
    NSComparisonResult compResult = [currentDate compare:dateToCompare];
    return (compResult == NSOrderedDescending && _daysInHistory && _daysInHistory <= dayDifference) || (compResult == NSOrderedAscending && _daysInFuture && _daysInFuture <= dayDifference);
}

- (BOOL)dateInCurrentMonth:(NSDate *)date{
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [_calendar components:unitFlags fromDate:self.firstOfCurrentMonth];
    NSDateComponents* comp2 = [_calendar components:unitFlags fromDate:date];
    return [comp1 year]  == [comp2 year] && [comp1 month] == [comp2 month];
}

- (NSDate *)dateWithOutTime:(NSDate *)datDate {
    if(!datDate) {
        datDate = [NSDate date];
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:datDate];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

#pragma mark - Cleanup

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
