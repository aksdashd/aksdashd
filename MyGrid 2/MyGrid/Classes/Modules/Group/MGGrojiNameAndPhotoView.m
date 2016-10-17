//
//  MGGrojiNameAndPhotoView.m
//  MyGrid
//
//  Created by Devashis on 28/06/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGGrojiNameAndPhotoView.h"

@implementation MGGrojiNameAndPhotoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)actionTakeImage
{
    [self.parent showOptionForCameraOrGallery];
}

- (IBAction)actionCancel
{
    self.hidden = YES;
}

- (IBAction)createNewCircle:(UIButton *)sender {
    [self.circleNameTextField endEditing:YES];
    if([self validateUserHasFilledAllManadatoryFields]){
        [self.parent createNewCircle:self.circleNameTextField.text];
    }
}

-(BOOL)validateUserHasFilledAllManadatoryFields{
    if([self.circleNameTextField.text length]== 0){
        return NO;
    }
    
    return YES;
}


@end
