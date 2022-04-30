John Bernardin <br />
Professor Chinomona <br />
MATH 2121: Mathematical Modeling and Simulation <br />
2022 <br />

# Youtube Model

The base model is YTModel_OneRun. This is a stochastic agent based model of how a YouTube
channel can expect to grow over a specified number of time steps. More information about
it can be found in the comments of the code itself. This program does not require any external
code to run, just make sure that you are not in any other folders while attempting to run this.

The Monte Carlo simulation is handled by YTModel_Histograms. This is based off of YTModel_OneRun
but does not require any other programs (including YTModel_OneRun) in order to run. More information
about this program can be found in its comments within the code.

The Exponential Base Investigation folder possesses code that changes the exponential base for 
multiple parameters. The programs in this folder include YTModel_CommentExponential,
YTModel_LikeExponential, YTModel_SubExponential, YTModel_ViewExponential, and 
YT_Model_ExponentialBase. To run these investigations, you may either run each program
independently or run YT_Model_ExponentialBase which will run all four of these programs.
Note that in order for YT_Model_ExponentialBase to run, each of the four other programs
must be in the same directory as YT_Model_ExponentialBase, so this must be kept in mind
if the user would like to move files around. More details about each can be found in their comments.

The Probability Investigation folder possesses code that changes the probabilities of multiple
parameters. The programs in this folder include YTModel_CommentNSProb, YTModel_CommentSubProb,
YTModel_DislikeProb, YTModel_LikeNSProb, YTModel_LikeSubProb, YTModel_SubPob, and 
YT_Model_Probability. Note that NS indicates not subscribes and Sub indicates subscribed. To 
run, each program may be run individually or YT_Model_Probability can be used to run all six
other programs. Note that in order for YT_Model_Probability to run, the other six programs 
must all be in the same directory.

The Graphs folder has multiple subfolders, all of which contain figures output from all other 
programs. I highly suggest looking to these, as my desktop took around 16-20 hours to 
produce that data (for my pc specifications are an 8 core, 3.90 Hz CPU and 16 Gb of RAM).
One Channel has the graphs for one channel over 52 days as well as the totals after that time,
Monte Carlo has graphs for total statistics over 50 and 100 channels, and Probability Investigation
and Exponential Base Investigation have the outputs for the respective programs. Note that 
SCD indicates the graph is showing subscribers, likes and dislikes, D indicates the graph 
is showing dislikes, and nothing appending the title indicates the graph is showing all five
stats of views, likes, dislikes, comments and subscribers.

When interpreting graphs, note that black indicates views, blue indicates likes, red indicates
subscribers, green indicates comments and yellow indicates dislikes.

