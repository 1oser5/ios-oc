//
//  UserTableViewCell.h
//  Artist
//
//  Created by 夏天乐 on 2018/12/9.
//  Copyright © 2018 HB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *artistImage;
@property (weak, nonatomic) IBOutlet UILabel *workLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UIImageView *workImage;
@end

NS_ASSUME_NONNULL_END
