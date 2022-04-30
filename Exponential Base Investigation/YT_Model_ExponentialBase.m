%YT_MODEL_Exponential_Base
% This function runs an investigation of each exponential base in 
% YTModel_OneRun while holding any base not being investigated as
% constants. Note this is a driver function which requires all functions
% called to be in the same folder as this function.

% 03/2022 by John Bernardin

function YT_Model_ExponentialBase
    YTModel_ViewExponential(); % investigate a, the view exponential base
    YTModel_LikeExponential(); % investigate b, the like exponential base
    YTModel_SubExponential(); % investigate c, the subscribed exponential base
    YTModel_CommentExponential(); % investigate d, the comment exponential base
end