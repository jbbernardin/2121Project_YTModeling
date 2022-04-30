%YT_MODEL_Probability
% This function runs an investigation of each static probability in
% YTModel_OneRun while holding any probability not being investigated as
% constants. Note this is a driver function which requires all functions
% called to be in the same folder as this function.

% 03/2022 by John Bernardin

function YT_Model_Probability
    YTModel_LikeNSProbability(); % investigate the probability of liking if not subscribed
    YTModel_LikeSubProbability(); % investigate the probability of liking if subscribed
    YTModel_DislikeProbability(); % investigate the probability of disliking
    YTModel_CommentNSProbability(); % investigate the probability of commenting if not subscribed
    YTModel_CommentSubProbability(); % investigate the probability of commenting if subscribed
    YTModel_SubProbability(); % investigate the probability of subscribing
end