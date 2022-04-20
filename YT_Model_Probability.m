function YT_Model_Probability
tic
    YTModel_LikeNSProbability();
    YTModel_LikeSubProbability();
    YTModel_DislikeProbability();
    YTModel_CommentNSProbability();
    YTModel_CommentSubProbability();
    YTModel_SubProbability();
toc
end