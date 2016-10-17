//
//  MGUserChattingViewController.m
//  MyGrid
//
//  Created by Devashis on 25/04/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGUserChattingViewController.h"

#import "MGEmojiView.h"

#import <CoreText/CoreText.h>

#import "MGChatContentModel.h"

#import "MGUserDefaults.h"

#import "MGSelfChatTableViewCell.h"

@interface MGUserChattingViewController ()<UITextViewDelegate,
                                           EMojiViewDelegate,
                                           UITableViewDataSource,
                                           UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatTypingViewBottomConstraint;
@property (assign, nonatomic) NSInteger keyboardHeight;
@property (weak, nonatomic) IBOutlet UITextView *textView;

//Emoji View
@property (strong, nonatomic) MGEmojiView *emojiView;
@property (strong, nonatomic) NSArray *emojiArrayList;
@property (assign, nonatomic) BOOL bIsEmojiViewVisible;

//Chat View
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (strong, nonatomic)NSMutableArray *chatArray;

@end

@implementation MGUserChattingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bIsEmojiViewVisible = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didShowKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHideKeyboard:) name:UIKeyboardDidHideNotification object:nil];
    
    [self fetchEmojiFromDocumentsDirectory];
    
    self.textView.enablesReturnKeyAutomatically = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadEMojiView:(BOOL)showFlag
{
    if (self.emojiView == nil)
    {
        _emojiView = [[[NSBundle mainBundle] loadNibNamed:@"MGEmojiView" owner:self options:nil] objectAtIndex:0];
        [self.view addSubview:self.emojiView];
        self.emojiView.delegate = self;
    }
    NSInteger height = self.keyboardHeight;
    BOOL isKeyboardVisible = YES;
    if (height <= 0)
    {
        isKeyboardVisible = NO;
        height = 260;
    }
    float y = self.view.frame.size.height - height;
    CGRect emojiViewFrame = CGRectMake(0, y, self.view.frame.size.width, height);
    self.emojiView.frame = emojiViewFrame;
    [self.emojiView setupProductListWirhArray:self.emojiArrayList];
    if (showFlag)
    {
        self.bIsEmojiViewVisible = YES;
        [self.emojiView setHidden:NO];
        [self.textView resignFirstResponder];
        self.chatTypingViewBottomConstraint.constant = self.emojiView.frame.size.height;
    }
    else
    {
        self.bIsEmojiViewVisible = NO;
        [self.emojiView setHidden:YES];
        if (isKeyboardVisible)
        {
            [self.textView becomeFirstResponder];
        }
        else
        {
            self.chatTypingViewBottomConstraint.constant = 0;
        }
    }
    
    
}


- (void)fetchEmojiFromDocumentsDirectory
{
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.emojiHandler fetchEmojisFromDocumentsDirectory:^(NSArray *list, NSError *error) {
            if (!error)
            {
                self.emojiArrayList = list;
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    [self loadEMojiView:NO];
                });
                
            }
            else
            {
                //Alert View
            }
        }];
        
    }); 

   
}

#pragma mark - EmojiViewDelegate
- (void)didSelectEmojiAtIndexItem:(NSInteger)item
{
    CGRect textFrame = [self.textView.text boundingRectWithSize:CGSizeMake(self.textView.frame.size.width, self.textView.frame.size.height)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:nil
                                                context:nil];
    NSLog(@"height : %f" ,textFrame.size.height);
    
    MGEmojiHandler *handler = [MGEmojiHandler new];
    NSString *imageName = [NSString stringWithFormat:@"%li.png",(long)item];
    UIImage *imageForPost = [handler getEMoji:imageName];
    //UIImageView *emojiImgView = [[UIImageView alloc] initWithImage:imageForPost];
    //emojiImgView.frame = CGRectMake(textFrame.size.width + 2, -20, 10, 10);
  
    //NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.textView.text];
    NSMutableAttributedString *attributedString = [self.textView.attributedText mutableCopy];
    
    NSTextAttachment *imageAttachment = [NSTextAttachment new];
    [imageAttachment setBounds:CGRectMake(0, 0, 30, 30)];
    imageAttachment.image = imageForPost;
    NSAttributedString *stringWithImage = [NSAttributedString attributedStringWithAttachment:imageAttachment];
    
    
    [attributedString replaceCharactersInRange:NSMakeRange(attributedString.length, 0) withAttributedString:stringWithImage];
    self.textView.attributedText = attributedString;
    
    
}

#pragma mark - Action Methods

- (IBAction)actionBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionEMojiButton
{
    if (self.emojiView.hidden == YES)
    {
        [self loadEMojiView:YES];
    }
    else
    {
        [self loadEMojiView:NO];
    }
}

- (IBAction)actionPost
{
    if (self.chatArray == nil)
    {
        _chatArray = [NSMutableArray new];
    }
    
    MGChatContentModel *chatModel = [MGChatContentModel new];
    chatModel.userId = [[MGUserDefaults sharedDefault] getUserId];
    chatModel.userType = UserType_Self;
    chatModel.chatText = self.textView.attributedText;
    
    [self.chatArray addObject:chatModel];
    [self.chatTableView reloadData];
    
    self.textView.text = nil;
}

#pragma mark - Keyboard Notifications

- (void)didShowKeyboard:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *keyboardFrameInfo = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    CGRect keyboardFrame = [keyboardFrameInfo CGRectValue];
    self.keyboardHeight = keyboardFrame.size.height;
    self.chatTypingViewBottomConstraint.constant = keyboardFrame.size.height;
}

- (void)didHideKeyboard:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Update the UI
        if (self.bIsEmojiViewVisible == NO)
        {
            self.chatTypingViewBottomConstraint.constant = 0;
        }
    });
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - Table View delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.chatArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGChatContentModel *chatModel = self.chatArray[indexPath.row];
    NSAttributedString *attrStr = chatModel.chatText;
    CGFloat width = self.textView.frame.size.width; // whatever your desired width is
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return rect.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGSelfChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelfCellIdentifier"];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MGSelfChatTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    MGChatContentModel *chatModel = self.chatArray[indexPath.row];
    NSAttributedString *attrStr = chatModel.chatText;
    cell.chatLabel.attributedText = attrStr;
    cell.chatLabel.textAlignment = NSTextAlignmentRight;
    return cell;
}

@end
