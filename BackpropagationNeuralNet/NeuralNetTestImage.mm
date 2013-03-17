//
//  NeuralNetTestImage.m
//  BackpropagationNeuralNet
//
//  Created by jay on 2/13/13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#import "NeuralNetTestImage.h"
#import "ImageHelper.h"

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

#define NORMALIZEHEIGHT(x) (((FP_TYPE)(x)+1.0)*(FP_TYPE)height/2.0)

#define NORMALIZEWIDTH(x) (((FP_TYPE)(x)+1.0)*(FP_TYPE)width/2.0)


-(void)imageTest1x1
{
    CGFloat oldy=0,oldx=0;
    BOOL first=YES;
    for (CGFloat x=-width; x < width; x+=2.0)
    {
        float inData[2];
        inData[0]=(float)x/(float)width;
        [nnh feedForward:inData];
        CGFloat y=NORMALIZEHEIGHT([nnh outValue:0]);
        CGPoint ptFrom={oldx,oldy};
        CGPoint ptTo={(x+width)/2,y};
        if (!first)
            [self pLine:ptFrom ptTo:ptTo factor:1 lineWidth:1.5];
        first=NO;
        oldx=(x+width)/2;
        oldy=y;
    }
}

-(void)imageTest1x2
{
    CGFloat oldy=0,oldx=0;
    BOOL first=YES;
    for (CGFloat x=-width; x < width; x+=2.0)
    {
        float inData[2];
        inData[0]=(float)x/(float)width;
        [nnh feedForward:inData];
        CGFloat xr=NORMALIZEWIDTH([nnh outValue:0]);
        CGFloat y=NORMALIZEHEIGHT([nnh outValue:1]);
        CGPoint ptFrom={oldx,oldy};
        CGPoint ptTo={xr,y};
        if (!first)
            [self pLine:ptFrom ptTo:ptTo factor:1 lineWidth:1.5];
        first=NO;
        oldx=xr;
        oldy=y;
    }
}


-(UIImage*)imageTest2x1
{
    CFTimeInterval start= CACurrentMediaTime();
    UIImage *image = [UIImage imageNamed:@"500"];
	// Create a bitmap
	unsigned char *bitmap = [ImageHelper convertUIImageToBitmapRGBA8:image];
    // Create a UIImage using the bitmap
	
    for (int y=0; y < image.size.height;y++)
    {
        unsigned char *scanLine=&bitmap[y*(int)image.size.width*4];
        for (int x=0; x < image.size.width;x++)
        {
            float inData[2];
            inData[0]=((float)x/(float)width)*2.0-1.0;
            inData[1]=((float)y/(float)height)*2.0-1.0;
            [nnh feedForward:inData];
            float y = [nnh outValue:0];
            if (y < 0)
            {
                y=-y;
                y*=100;
                scanLine[1]+=y;
               
            }
            else
            {
                y*=100;
                scanLine[0]+=y;
            }
            scanLine+=4;
        }
    }
    for (int i=0; i < [[nnh trainDataSet] setsCount]; i++)
    {
        int x=NORMALIZEWIDTH([[nnh trainDataSet] dataToInputSet:i][0]);
        int y=NORMALIZEHEIGHT([[nnh trainDataSet] dataToInputSet:i][1]);
        int v=[[nnh trainDataSet] dataToOutputSet:i][0];

        if ((x >= 1)&&(x < image.size.width-1)&&(y >= 1)&&(x < image.size.height-1))
        {
            unsigned char *scanLine=&bitmap[(x-1+(y-1)*(int)image.size.width)*4];
            for (int i=0; i < 3; i++)
            {
                scanLine[0]=0;
                scanLine[1]=0;
                scanLine[2]=0;
                scanLine+=4;
            }
            scanLine=&bitmap[(x-1+(y+1)*(int)image.size.width)*4];
            for (int i=0; i < 3; i++)
            {
                scanLine[0]=0;
                scanLine[1]=0;
                scanLine[2]=0;
                scanLine+=4;
            }
            scanLine=&bitmap[(x+y*(int)image.size.width)*4];
            if (v==1)
            {
            
                scanLine[0-4]=0;
                scanLine[1-4]=0;
                scanLine[2-4]=0;
                scanLine[0]=255;
                scanLine[1]=0;
                scanLine[2]=0;
                scanLine[0+4]=0;
                scanLine[1+4]=0;
                scanLine[2+4]=0;
            }
            else
            {
                scanLine[0-4]=0;
                scanLine[1-4]=0;
                scanLine[2-4]=0;
                scanLine[0]=0;
                scanLine[1]=255;
                scanLine[2]=0;
                scanLine[0+4]=0;
                scanLine[1+4]=0;
                scanLine[2+4]=0;
            }
        }
    }
    
    
	UIImage *imageCopy = [ImageHelper convertBitmapRGBA8ToUIImage:bitmap withWidth:image.size.width withHeight:image.size.height];
	// Cleanup
	if(bitmap) {
		free(bitmap);
		bitmap = nil;
	}
    NSLog(@"t for image=%f", CACurrentMediaTime()-start);

	return imageCopy;
}

-(void)imageTrain1x1
{
    for (int i=0; i < [[nnh trainDataSet] setsCount]; i++)
    {
        CGFloat x=NORMALIZEWIDTH([[nnh trainDataSet] dataToInputSet:i][0]);
        CGFloat y=NORMALIZEHEIGHT([[nnh trainDataSet] dataToOutputSet:i][0]);
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
        CGFloat x=NORMALIZEWIDTH([[nnh trainDataSet] dataToOutputSet:i][0]);
        CGFloat y=NORMALIZEHEIGHT([[nnh trainDataSet] dataToOutputSet:i][1]);
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
    if(2==[[nnhin trainDataSet] inputNeurons])
    {
        return [self imageTest2x1];
    }
    
    UIImage *_image;
    CGRect rect = CGRectMake(0.0f, 0.0f, width+padding*2.0, height+padding*2.0);
    UIGraphicsBeginImageContext(rect.size);
    ctx = UIGraphicsGetCurrentContext();
    const CGFloat *color = CGColorGetComponents([[UIColor lightGrayColor] CGColor]);
    CGContextSetFillColor(ctx, color);
    CGContextFillRect(ctx, rect);
    
    CGContextSetRGBStrokeColor(ctx,0,0,0,1);
    
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
