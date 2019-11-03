function measAngs = getBoundary(coords,img,object,imgName)

% getBoundary.m
% This function takes the coordinates of the boundary endpoints as inputs, scales them appropriately, and constructs the boundary line segments. 
% A line is then extended in both directions from the center of each curvelet and the angle of intersection with the boundary is found. 
% 
% Inputs:
% 
% coords - the locations of the endpoints of each line segment making up the boundary
% 
% img - the image being measured
% 
% extent - the location of the lower left corner, width and height of the image in the figure window, in scaled units
% 
% object - a struct containing the center and angle of each measured curvelet, generated by the newCurv function
% 
% Output:
% 
% histData = the bins and counts of the angle histogram
% 
% Carolyn Pehlke, Laboratory for Optical and Computational Instrumentation, November 2010


rows = coords(:,2);
cols = coords(:,1);
% structs that will hold the boundary line segments and the lines from the
% curvelets
lineSegs(1:length(coords)-1) = struct('slope',[],'intercept',[],'pointVals',[],'angle',[],'intAngles',[],'intLines',[],'intDist',[]);
curvLines(1:length(object)) = struct('center',[],'angle',[],'slope',[],'orthoSlope',[],'intercept',[],'orthoIntercept',[],'orthoPvals',[],'pointVals',[]);

% finding every point in the boundary line segments and calculating the
% angle of the segment
for aa = 2:length(coords)
    
    lineSegs(aa-1).slope = (rows(aa) - rows(aa-1))/(cols(aa) - cols(aa-1));
    lineSegs(aa-1).intercept = rows(aa) - (cols(aa)*lineSegs(aa-1).slope);
    if isinf(lineSegs(aa-1).slope)
        lineSegs(aa-1).angle = 90;
    else
        lineSegs(aa-1).angle = atand(-lineSegs(aa-1).slope);
    end
    if lineSegs(aa-1).angle < 0
        lineSegs(aa-1).angle = lineSegs(aa-1).angle + 180;
    end
    if cols(aa-1) <= cols(aa)
        colVals = cols(aa-1):1:cols(aa);
    else
        colVals = cols(aa-1):-1:cols(aa);
    end
    rowVals = round(lineSegs(aa-1).slope * colVals + lineSegs(aa-1).intercept);
    lineSegs(aa-1).pointVals = horzcat(rowVals',colVals');
end

% finding each point of the line passing through the centerpoint of the
% curvelet with slope of tan(curvelet angle)
for bb = 1:length(object)
    curvLines(bb).center = object(bb).center;
    curvLines(bb).angle = object(bb).angle;
    curvLines(bb).slope = -tand(object(bb).angle);
    curvLines(bb).orthoSlope = tand(object(bb).angle);
    curvLines(bb).intercept = object(bb).center(1) - (curvLines(bb).slope)*object(bb).center(2);
    curvLines(bb).orthoIntercept = object(bb).center(1) - (curvLines(bb).orthoSlope)*object(bb).center(2);
    colVals = 1:size(img,2);
    rowVals = round((curvLines(bb).slope)*colVals + curvLines(bb).intercept);
    curvLines(bb).pointVals = horzcat(rowVals',colVals');
    colVals2 = 1:size(img,2);
    rowVals2 = round((curvLines(bb).orthoSlope)*colVals + curvLines(bb).orthoIntercept);
    curvLines(bb).orthoPvals = horzcat(rowVals2',colVals2');    
    
%     plot(colVals,rowVals)
end

% finding the angles and points of intersection between the curvelet lines and the
% boundary line segments
for cc = 1:length(lineSegs)
    for dd = 1:length(curvLines)
        intersection1 = intersect(lineSegs(cc).pointVals,curvLines(dd).pointVals,'rows');
        intersection2 = intersect(lineSegs(cc).pointVals,curvLines(dd).orthoPvals,'rows');
        
        if intersection1
            tempAng(dd) = max(lineSegs(cc).angle,curvLines(dd).angle) - min(lineSegs(cc).angle,curvLines(dd).angle);
            tempLines(dd) = dd;
            tempDist(dd) = min(sqrt((curvLines(dd).center(1) - lineSegs(cc).pointVals(:,1)).^2 + (curvLines(dd).center(2) - lineSegs(cc).pointVals(:,2)).^2));
        elseif intersection2
            tempAng(dd) = max(lineSegs(cc).angle,curvLines(dd).angle) - min(lineSegs(cc).angle,curvLines(dd).angle);
            tempLines(dd) = dd;
            tempDist(dd) = min(sqrt((curvLines(dd).center(1) - lineSegs(cc).pointVals(:,1)).^2 + (curvLines(dd).center(2) - lineSegs(cc).pointVals(:,2)).^2));
        else
            tempAng(dd) = -1000;
            tempLines(dd) = -1000;
            tempDist(dd) = -1000;
        end
        
    end
    
    idx = tempAng > -1000;
    tempAng = tempAng(idx);
    
    idx = tempAng > 180;
    tempAng(idx) = tempAng(idx) - 180;
    
    idx = tempAng > 90;
    tempAng(idx) = 180 - tempAng(idx);
    lineSegs(cc).intAngles = tempAng;
    
    idx = tempLines > -1000;
    lineSegs(cc).intLines = tempLines(idx);
    
    idx = tempDist > -1000;
    lineSegs(cc).intDist = tempDist(idx);
        
end

for ee = 1:length(lineSegs)-1
    for ff = (ee+1):length(lineSegs)-1
        [intTest iEE iFF] = intersect(lineSegs(ee).intLines,lineSegs(ff).intLines);
        if intTest
            idxE = lineSegs(ee).intDist(iEE) >= lineSegs(ff).intDist(iFF);
            idxF = lineSegs(ff).intDist(iFF) > lineSegs(ee).intDist(iEE);
            lineSegs(ee).intDist(idxE) = [];
            lineSegs(ee).intLines(idxE) = [];
            lineSegs(ee).intAngles(idxE) = [];
            lineSegs(ff).intDist(idxF) = [];
            lineSegs(ff).intLines(idxF) = [];
            lineSegs(ff).intAngles(idxF) = [];
        end
    end
end

% output
measAngs = horzcat(lineSegs.intAngles);

     
