//
//  ArtistTableViewCell.h
//  Artist
//
//  Created by 夏天乐 on 2018/12/10.
//  Copyright © 2018 HB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArtistTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *artistImage;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *artistScrollView;

@end

NS_ASSUME_NONNULL_END
