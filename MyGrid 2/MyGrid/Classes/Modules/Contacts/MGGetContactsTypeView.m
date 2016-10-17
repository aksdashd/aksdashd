//
//  MGGetContactsTypeView.m
//  MyGrid
//
//  Created by Devashis on 21/03/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGGetContactsTypeView.h"

#import "MGGetContactsTypeTableViewCell.h"


@interface MGGetContactsTypeView ()<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tableContacts;
}

@end

@implementation MGGetContactsTypeView

#pragma mark - Action Methods

- (IBAction)actionCancel:(id)sender
{
    [self removeFromSuperview];
}

#pragma mark - TableView Methods
- (void)reloadContentsInTableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableContacts reloadData];
    });
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.typeOfTable == TypeOfTable_SocialMediaOptions)
    {
        return 2;
    }
    else
    {
        return [self.delegate.contactsMainModel.contactsContainer count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.typeOfTable == TypeOfTable_SocialMediaOptions)
    {
        static NSString *identifier = @"TableContactsIdentifier";
        
        MGGetContactsTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MGGetContactsTypeTableViewCell" owner:self options:nil] objectAtIndex:0];
            
        }
        
        //    CGRect imageRect = cell.image.frame;
        //    cell.image.frame = CGRectMake(imageRect.origin.x, imageRect.origin.y, imageRect.size.height, imageRect.size.height);
        cell.imageWidthConstraint.constant = cell.image.frame.size.height;
        cell.image.layer.cornerRadius = cell.image.frame.size.height / 2;
        
        switch (indexPath.row)
        {
            case ContactTypes_Facebook:
            {
                
                cell.image.image = [UIImage imageNamed:@"fb_icon"];
                
                cell.labelText.text = @"Import Friends from Facebook";
                
            }
                break;
            case ContactTypes_GooglePlus:
            {
                
                cell.image.image = [UIImage imageNamed:@"googleplus_icon"];
    
                cell.labelText.text = @"Import Friends from Google ";
                
                //GIDSignInButton *gidButton = [[GIDSignInButton alloc] initWithFrame:cell.contentView.frame];
                //[gidButton se]
                //gidButton.style = kGIDSignInButtonStyleIconOnly;
                //[cell.contentView addSubview:gidButton];
                
                
            }
                break;
            case ContactTypes_Contact:
            {
                
                
                cell.image.image = [UIImage imageNamed:@"import_friends@1x"];
                
                cell.labelText.text = @"Import Friends from Phonebook";
            }
                break;
        }
        //cell.textLabel.text =;
        return  cell;
    }
    else
    {
        static NSString *identifier = @"TableContactSelectedIdentifier";
        
        MGGetContactsTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MGGetContactsTypeTableViewCell" owner:self options:nil] objectAtIndex:0];
            
            
        }
        
        MGContactItemsModel *model = self.delegate.contactsMainModel.contactsContainer[indexPath.row];
        
        cell.labelText.text = model.displayName;
        //cell.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.imageURL]]];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.typeOfTable == TypeOfTable_SocialMediaOptions)
    {
        switch (indexPath.row) {
            case ContactTypes_Facebook:
            {
                [self.delegate didSelectOption:ContactTypes_Facebook selectedIndexPath:indexPath];
            }
                break;
            case ContactTypes_GooglePlus:
            {
                [self.delegate didSelectOption:ContactTypes_GooglePlus selectedIndexPath:indexPath];
            }
                break;
            case ContactTypes_Contact:
            {
               [self.delegate didSelectOption:ContactTypes_Contact selectedIndexPath:indexPath];
            }
                break;
        }
        
    }
    else
    {
        
        [self.delegate didSelectOption:ContactTypes_GooglePlus selectedIndexPath:indexPath];
        self.typeOfTable = TypeOfTable_SocialMediaOptions;
        [self reloadContentsInTableView];
    }
}

@end
