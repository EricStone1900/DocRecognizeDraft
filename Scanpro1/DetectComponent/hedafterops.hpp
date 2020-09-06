//
//  hedafterops.hpp
//  SSDMobilenet
//
//  Created by song on 2019/4/11.
//  Copyright © 2019年 song. All rights reserved.
//

#ifndef hedafterops_hpp
#define hedafterops_hpp

#include <stdio.h>
#include <opencv2/imgproc/imgproc.hpp>
#include <iostream>

#include <opencv2/opencv.hpp>

#include <algorithm>
#include <array>
//在具体调用的地方，看这几个常量的解释
const int kHoughLinesPThreshold = 50;   //阈值 值越大线越长
const double kHoughLinesPMinLinLength = 15.0;  //最小可接受的线段
const double kHoughLinesPMaxLineGap = 3.0;  //最大允许间隔

const int kMergeLinesMaxDistance = 5;
const int kIntersectionMinAngle = 45;
const int kIntersectionMaxAngle = 135;
const double kCloserPointMaxDistance = 6.0;
const double kRectOpposingSidesMinRatio = 0.5;
const int kPointOnLineMaxOffset = 30;   //拐角适当延长
const int kSameSegmentsMaxAngle = 5;

const int maxLines = 100;   //最多一百条直线参与计算
const int maxPoints = 20;   //点的复杂度是O^4 限制20
struct Corner {
    cv::Point point;
    std::vector<cv::Vec4i> segments;
};


static bool IsPointOnLine(const cv::Point point, const cv::Vec4i line);

//https://gist.github.com/ceykmc/18d3f82aaa174098f145
static std::array<int, 3> Cross(const std::array<int, 3> &a,
                                const std::array<int, 3> &b);

//这个版本，line 是看成一条可以无限延长的直线
static bool GetIntersection(const cv::Vec4i &line_a, const cv::Vec4i &line_b, cv::Point &intersection);

//这个版本，line实际上是有限长度的线段，所以还额外检测了一下 point 是否在线段上
static bool GetSegmentIntersection(const cv::Vec4i &line_a, const cv::Vec4i &line_b, cv::Point &intersection);

//http://opencv-users.1802565.n2.nabble.com/Angle-between-2-lines-td6803229.html
//http://stackoverflow.com/questions/2339487/calculate-angle-of-2-points
static int GetAngleOfLine(const cv::Vec4i &line);

static int GetAngleOfTwoPoints(const cv::Point &point_a, const cv::Point &point_b);
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

/**
 RefLineVec4i 比较特殊，如果把它看成向量的话，它的反向是遵守一定的规则的。
 RefLineVec4i 里面的两个点，总是从左往右的方向，如果 RefLine 和 Y 轴平行(区分不了左右)，则按照从下往上的方向
 */
typedef cv::Vec4i RefLineVec4i;

static bool IsTwoRefLineCloseToEachOther(RefLineVec4i line_a, RefLineVec4i line_b);


static RefLineVec4i GetRefLine(const cv::Vec4i line, int image_width, int image_height);

static bool SortPointsByXaxis(const cv::Point &a, const cv::Point &b);

static bool SortPointsByYaxis(const cv::Point &a, const cv::Point &b);

static bool SortCornersByXaxis(const Corner &a, const Corner &b);

static bool SortCornersByYaxis(const Corner &a, const Corner &b);

static bool IsSegmentsHasSameSegment(const std::vector<cv::Vec4i> segments, const cv::Vec4i segment, int image_width);

/**
 HoughLinesP检测出来的是线段，是有长度的。
 把每一个线段扩展成一个统一规格的 RefLineVec4i，形成一个 pair，然后调用这个函数，对这些 pair 进行合并。
 用RefLineVec4i来决策是否需要合并，对于需要合并的，则把对应的HoughLinesP线段重组成一个更长的线段。
 */
static std::vector<std::tuple<RefLineVec4i, cv::Vec4i> > MergeRefLineAndSegmentPairs(std::vector<std::tuple<RefLineVec4i,
                                                                                     cv::Vec4i> > ref_line_and_segment_pairs, int image_width, int image_height);

static double PointsDistance(const cv::Point &a, const cv::Point &b);

/**
 按照顺时针排序，对4个 corner 排序，得到 4 corners: top-left, top-right, bottom-right, bottom-left, index are 0, 1, 2, 3
 */
static std::vector<Corner> ArrangeRectCorners(std::vector<Corner> rect_corners);

/**
 一组策略，判断4个 corner 是否可以形成一个可信度高的矩形(有透视变换效果，所以肯定不是标准的长方形，而是一个梯形或平行四边形)
 4个 point 是已经经过ArrangeRectPoints排过序的
 4 points top-left, top-right, bottom-right, bottom-left, index are 0, 1, 2, 3
 */
static bool IsRectCornersReasonable(std::vector<Corner> rect_corners, int image_width);

//#define ENABLE_DEBUG_MODE
std::tuple<bool, std::vector<cv::Point>, std::vector<cv::Mat> > ProcessEdgeImage(cv::Mat edge_image, cv::Mat color_image, bool draw_debug_image);
//void getAffImage(unsigned char * pSrcImg,int Wsrc,int Hsrc,float * ppoints,int Wedge,int Hedge,unsigned char * pDstImg,int Wdst,int Hdst);
void __copyArrayToMat(unsigned char * pimage, int * shape,cv::Mat & imageMat);
void __copyMatToArr(cv::Mat & imageMat,unsigned char * pimage, int * shape);
bool getFloatImageColor(unsigned char * bitMap,int hi,int wi,int ci,float * outFloatImage,int ho,int wo);

void getAffImage(unsigned char *pSrcImg, int Wsrc, int Hsrc, float *ppoints, int Wedge, int Hedge,
                 unsigned char *pDstImg, int Wdst, int Hdst);

cv::Mat getAffImageTest(cv::Mat src);
cv::Mat getAffImageTest2(cv::Mat src, std::vector<cv::Point2f> corners, int outW, int outH);

#endif /* hedafterops_hpp */
