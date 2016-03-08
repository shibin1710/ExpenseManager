//
//  IRFAQViewController.m
//  ExpenseMobile
//
//  Created by Shibin S on 05/06/15.
//  Copyright (c) 2015 Shibin. All rights reserved.
//

#import "IRFAQViewController.h"
#import "SWRevealViewController.h"
#import "IRCommon.h"
#import "IRFAQQuestionCell.h"
#import "IRFAQAnswerCell.h"

@interface IRFAQViewController ()

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UITableView *FAQTableView;
@property (strong, nonatomic) NSArray *FAQArray;
@property (strong, nonatomic) NSMutableArray *questionArray;
@property (strong, nonatomic) NSMutableArray *answerArray;
@property (strong, nonatomic) NSMutableArray *selectedIndexPathArray;
@property (strong, nonatomic) NSMutableArray *addedIndexPathArray;
@property (strong, nonatomic) NSMutableArray *questionHeightArray;
@property (strong, nonatomic) NSMutableArray *answerHeightArray;

- (CGFloat)getTextHeight:(NSString*)string atFont:(UIFont*)font;
- (void)expandCellsForIndexPath:(NSIndexPath *)indexPath;
- (void)collapseCellsAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation IRFAQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    self.navigationItem.title = [IRCommon localizeText:@"FAQ"];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[IRCommon getDefaultFontForSize:17.0 isBold:YES]};
    
    self.FAQTableView.delegate = self;
    self.FAQTableView.dataSource = self;
    self.FAQTableView.separatorColor = [UIColor clearColor];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[IRCommon getDefaultFontForSize:17.0 isBold:YES]};
    self.selectedIndexPathArray = [[NSMutableArray alloc]init];
    self.addedIndexPathArray = [[NSMutableArray alloc]init];
    self.questionArray = [[NSMutableArray alloc]init];
    self.answerArray = [[NSMutableArray alloc]init];
    self.questionHeightArray = [[NSMutableArray alloc]init];
    self.answerHeightArray = [[NSMutableArray alloc]init];
    self.FAQArray = [IRCommon getArrayFromPlist:@"FAQ"];
    
    for (NSDictionary *FAQDictionary in self.FAQArray) {
        NSString *question = [FAQDictionary objectForKey:@"question"];
        NSString *answer = [FAQDictionary objectForKey:@"answer"];
        CGFloat questionHeight = [self getTextHeight:question atFont:[IRCommon getDefaultFontForSize:13 isBold:NO]];
        CGFloat answerHeight = [self getTextHeight:answer atFont:[IRCommon getDefaultFontForSize:13 isBold:NO]];
        [self.questionHeightArray addObject:[NSNumber numberWithFloat:questionHeight]];
        [self.answerHeightArray addObject:[NSNumber numberWithFloat:answerHeight]];
        [self.questionArray addObject:question];
        [self.answerArray addObject:answer];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

// Function      : getTextHeight:atFont:
// Purpose       : Get height of label depending on text
// Parameter     : text and font
// ReturnType    : CGFloat
// Comments      :

- (CGFloat)getTextHeight:(NSString*)string atFont:(UIFont*)font
{
    CGSize size = CGSizeMake(self.view.frame.size.width - 40, 1000);
    CGRect textRect = [string boundingRectWithSize:size
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:font}
                                           context:nil];
    return textRect.size.height;
}

// Function      : expandCellsForIndexPath:
// Purpose       : Insert new row when a cell is clicked
// Parameter     : indexPath
// ReturnType    : void
// Comments      :

- (void)expandCellsForIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedIndexPathArray addObject:indexPath];
    [self.addedIndexPathArray addObject:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
    [self.FAQTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
}

// Function      : collapseCellsAtIndexPath:
// Purpose       : Delete inserted row when a cell is clicked
// Parameter     : indexPath
// ReturnType    : void
// Comments      :

- (void)collapseCellsAtIndexPath:(NSIndexPath *)indexPath
{
    [self.FAQTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
    [self.addedIndexPathArray removeObject:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
    [self.selectedIndexPathArray removeObject:indexPath];
}

#pragma mark - UITableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.FAQArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int offset = 0;
    for (NSIndexPath *indexPath in self.selectedIndexPathArray) {
        if (indexPath.section == section)
            offset = 1; // If a cell is selected, one more row is added.
    }
    return 1 + offset;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *addedIndexPath;
    for (NSIndexPath *aIndexPath in self.addedIndexPathArray) {
        if ([indexPath isEqual:aIndexPath])
            addedIndexPath = aIndexPath;
    }
    
    if ([indexPath isEqual:addedIndexPath]) {
        IRFAQAnswerCell *cell = (IRFAQAnswerCell *)[tableView dequeueReusableCellWithIdentifier:@"AnswerCell"];
        if (!cell)
            cell = [[IRFAQAnswerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AnswerCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.exclusiveTouch = YES;
        cell.answer.attributedText = [[NSAttributedString alloc]initWithString:NSLocalizedString([self.answerArray objectAtIndex:indexPath.section],nil)];
        return cell;
    }
    else {
        IRFAQQuestionCell *cell = (IRFAQQuestionCell *)[tableView dequeueReusableCellWithIdentifier:@"QuestionCell"];
        if (!cell)
            cell = [[IRFAQQuestionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuestionCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.exclusiveTouch = YES;
        NSString *questionText = NSLocalizedString([self.questionArray objectAtIndex:indexPath.section],nil);
        NSMutableAttributedString *attributedQuestionText = [[NSMutableAttributedString alloc]initWithString:questionText];
        NSMutableAttributedString *questionNumberAttributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Q%li. ",(long)indexPath.section + 1]];
        [questionNumberAttributedString addAttribute:NSForegroundColorAttributeName value:[IRCommon getThemeColor] range:NSMakeRange(0, questionNumberAttributedString.length)];
        [questionNumberAttributedString appendAttributedString:attributedQuestionText];
        cell.question.attributedText = questionNumberAttributedString;
        return cell;
    }
}

#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (NSIndexPath *aIndexPath in self.addedIndexPathArray) {
        if ([indexPath isEqual:aIndexPath]) {
            NSNumber *answerHeight = [self.answerHeightArray objectAtIndex:indexPath.section];
            return answerHeight.floatValue + 20.0f;
        }
    }
    
    NSNumber *questionHeight = [self.questionHeightArray objectAtIndex:indexPath.section];
    return questionHeight.floatValue + 25.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *addedIndexPath;
    for (NSIndexPath *aIndexPath in self.addedIndexPathArray) {
        if ([indexPath isEqual:aIndexPath])
            addedIndexPath = aIndexPath;
    }
    
    if (addedIndexPath && [addedIndexPath isEqual:indexPath]) return;
    [self.FAQTableView beginUpdates];
    for (NSIndexPath *selectedIndexPath in self.selectedIndexPathArray) {
        if ([selectedIndexPath isEqual:indexPath]) {
            [self collapseCellsAtIndexPath:indexPath];
            [self.FAQTableView endUpdates];
            return;
        }
    }
    
    //    if ([self.addedIndexPathArray count]) {
    //        [self collapseCellsAtIndexPath:[selectedIndexPathArray objectAtIndex:0]];
    //    }
    
    [self expandCellsForIndexPath:indexPath];
    [self.FAQTableView endUpdates];
    [self.FAQTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

#pragma mark - Dealloc method

-(void)dealloc
{
    if (self.FAQTableView) {
        self.FAQTableView.dataSource = nil;
        self.FAQTableView.delegate = nil;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
