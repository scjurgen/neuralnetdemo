//
//  NeuralNetTestImage.m
//  BackpropagationNeuralNet
//
//  Created by jay on 2/13/13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#import "NeuralNetTestImage.h"
@interface NeuralNetTestImage()
{
    CGFloat padding;
    CGFloat width, height;
    NeuralNetHandler *nnh;
    CGContextRef ctx;
}


@end

@implementation NeuralNetTestImage


- (void)pLine:(CGPoint)ptFrom ptTo:(CGPoint)ptTo factor:(NSInteger)factor lineWidth:(CGFloat)lineWidth
{
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, padding+ptFrom.x*factor, padding+ptFrom.y*factor);
    CGContextAddLineToPoint(ctx, padding+ptTo.x*factor, padding+ptTo.y*factor);
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextStrokePath(ctx);
}

- (void) outline:(CGPoint)pt factor:(NSInteger)factor
{
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, padding+pt.x*factor, padding+pt.y*factor);
    CGContextAddLineToPoint(ctx, padding+(pt.x+1)*factor, padding+(pt.y)*factor);
    CGContextAddLineToPoint(ctx, padding+(pt.x+1)*factor, padding+(pt.y+1)*factor);
    CGContextAddLineToPoint(ctx, padding+(pt.x)*factor, padding+(pt.y+1)*factor);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextStrokePath(ctx);
}


-(void)imageTest1x1
{
    CGFloat oldy=0,oldx=0;
    for (CGFloat x=0; x < width; x++)
    {
        float inData[2];
        inData[0]=(float)x/(float)width;
        [nnh feedForward:inData];
        CGFloat y=[nnh outValue:0]*height;
        CGPoint ptFrom={oldx,oldy};
        CGPoint ptTo={x,y};
        if (x!=0)
            [self pLine:ptFrom ptTo:ptTo factor:1 lineWidth:1.5];
        oldx=x;
        oldy=y;
    }
}

-(void)imageTest1x2
{
    CGFloat oldy=0,oldx=0;
    for (CGFloat x=0; x < width; x++)
    {
        float inData[2];
        inData[0]=(float)x/(float)width;
        [nnh feedForward:inData];
        CGFloat xr=[nnh outValue:0]*height;
        CGFloat y=[nnh outValue:1]*height;
        CGPoint ptFrom={oldx,oldy};
        CGPoint ptTo={xr,y};
        if (x!=0)
            [self pLine:ptFrom ptTo:ptTo factor:1 lineWidth:1.5];
        oldx=xr;
        oldy=y;
    }
}

-(void)imageTest2x1
{
    CGFloat oldy=0,oldx=0;
    for (CGFloat y=0; y < height; y+=10)
    {
        for (CGFloat x=0; x < width; x+=10)
        {
            FP_TYPE inData[3];
            inData[0]=(FP_TYPE)x/(FP_TYPE)width;
            inData[1]=(FP_TYPE)y/(FP_TYPE)height;
            [nnh feedForward:inData];
            CGFloat z=[nnh outValue:0]*height;
            CGPoint ptFrom={oldx,oldy};
            CGPoint ptTo={x,y};
            [self pLine:ptFrom ptTo:ptTo factor:1 lineWidth:1.5];
            oldx=x;
            oldy=y;
        }
    }
}

-(void)imageTrain1x1
{
    for (int i=0; i < [[nnh trainDataSet] setsCount]; i++)
    {
        CGFloat x=(FP_TYPE)[[nnh trainDataSet] dataToInputSet:i][0]*(FP_TYPE)width;
        CGFloat y=(FP_TYPE)[[nnh trainDataSet] dataToOutputSet:i][0]*(FP_TYPE)height;
        CGPoint ptFrom={x,y};
        CGPoint ptTo={x,y+1};
        [self pLine:ptFrom ptTo:ptTo factor:1 lineWidth:5.0];
    }
    
}


-(void)imageTrain1x2
{
    CGFloat oldx,oldy;
    for (int i=0; i < [[nnh trainDataSet] setsCount]; i++)
    {
        CGFloat x=(FP_TYPE)[[nnh trainDataSet] dataToOutputSet:i][0]*(FP_TYPE)width;
        CGFloat y=(FP_TYPE)[[nnh trainDataSet] dataToOutputSet:i][1]*(FP_TYPE)height;
        CGPoint ptFrom={oldx,oldy};
        CGPoint ptTo={x,y};
        if (i!=0)
        {
            [self pLine:ptFrom ptTo:ptTo factor:1 lineWidth:1.0];
        }
        oldx=x;
        oldy=y;
    }
}


-(UIImage*)getTestImage:(NeuralNetHandler *)nnhin
{
    width = 500.0;
    height = 500.0;
    padding = 4.0;
    nnh=nnhin;
    UIImage *_image;
    CGRect rect = CGRectMake(0.0f, 0.0f, width+padding*2.0, height+padding*2.0);
    UIGraphicsBeginImageContext(rect.size);
    ctx = UIGraphicsGetCurrentContext();
    const CGFloat *color = CGColorGetComponents([[UIColor lightGrayColor] CGColor]);
    CGContextSetFillColor(ctx, color);
    CGContextFillRect(ctx, rect);
    
    CGContextSetRGBStrokeColor(ctx,0,0,0,1);
    
    CGFloat oldy=0,oldx=0;
    // show testset
    switch ([[nnh trainDataSet] inputNeurons])
    {
        case 1:
            switch([[nnh trainDataSet] outputNeurons]) {
                case 1: [self imageTest1x1];break;
                case 2: [self imageTest1x2];break;
            }
            break;
        case 2:
            [self imageTest2x1];
            break;
    }
    
    // show train set
    CGContextSetRGBStrokeColor(ctx,1,0,0,1);
    
    switch ([[nnh trainDataSet] inputNeurons])
    {
        case 1:
            switch([[nnh trainDataSet] outputNeurons]) {
                case 1: [self imageTrain1x1];break;
                case 2: [self imageTrain1x2];break;
            }
            break;
    }
    _image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return _image;
}

@end
