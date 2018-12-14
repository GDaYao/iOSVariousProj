//
//  UITableView+CustomTV.h
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (CustomTV)

/**
 directly import this custom class,start init with arguments.

 @param BGColor UIColor object.
 @param TVFrame Set `UITableView` frame.Also you can set CGRectZero and use Masonry layout.
 @param tableViewCell Custom new create xxx.nib/xxx.xib subclass of UITableViewCell.
 @param kCellIdentifier Set `UITableViewCell` identifier.
 @param showV Need show vertical scroll indicator.
 @param showH Need show horizontal scroll indicator.
 @param separatorStyle UITableView separactor style.
 @param delegateVC Set UITableView delegate.
 @return Back UITableView object.
 */
+ (UITableView *)InitTVWithBGColor:(UIColor *)BGColor TVFrame:(CGRect)TVFrame registerTableViewCell:(UITableViewCell *)tableViewCell tableViewCellID:(NSString *)kCellIdentifier showVerticalSI:(BOOL)showV showHorizontalSI:(BOOL)showH separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle TVDelegateVC:(id)delegateVC;


@end

NS_ASSUME_NONNULL_END
