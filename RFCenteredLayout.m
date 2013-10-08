//
//  RFCenteredLayout.m
//  CenteredLayout
//
//  Created by Bryce Redd on 10/8/13.
//  Copyright (c) 2013 Bryce Redd. All rights reserved.
//

#import "RFCenteredLayout.h"

@implementation RFCenteredLayout

- (CGSize)collectionViewContentSize {
    CGSize size = [super collectionViewContentSize];
    
    if(self.demandElasticity) {
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
            size.height = MAX(self.collectionView.frame.size.height+1, size.height);
        else
            size.width = MAX(self.collectionView.frame.size.width+1, size.width);
    }
    
    return size;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    if(self.demandElasticity)
        return !(CGSizeEqualToSize(newBounds.size, self.collectionView.frame.size));
    else
        return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}

// to get the items in the center we need to be sneaky about
// which rect of index paths we ask for.  our goal here is to
// minimize the changes we need to the flow layout, so we'll
// leave all the internal positioning the same, just make changes
// to the rect for which we ask layout attributes, and the layout
// attributes as they come back

- (CGRect) adjustFrame:(CGRect)frame {
    CGSize contentSize = [super collectionViewContentSize];
    CGSize collectionSize = self.collectionView.frame.size;
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        if(contentSize.height <= collectionSize.height) {
            frame.origin.y += (collectionSize.height - contentSize.height) / 2.f;
        }
    } else {
        if(contentSize.width <= collectionSize.width) {
            frame.origin.x += (collectionSize.width - contentSize.width) / 2.f;
        }
    }
    
    return frame;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    
    for(UICollectionViewLayoutAttributes* attributes in array) {
        attributes.frame = [self adjustFrame:attributes.frame];
    }
    
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    attributes.frame = [self adjustFrame:attributes.frame];
    
    return attributes;
}


@end
