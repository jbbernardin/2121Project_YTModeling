function YTModel_SubProbability
%YTMODEL_SubProbability
% This function runs an investigation on the probability of subscribing 
% in YTModel_OneRun. Each other probability is held as a
% constant, while the investigated probability is iterated by a specified
% amount over Niterations iterations. The totals for each of the
% Niterations runs of YTModel_OneRun are then graphed.

% 03/2022 by John Bernardin

tic % tracker for outputting time

rng(42) % seed to account for variation in the investigation

% Basic Statistics
Ndays = 52; % number of days
Nusers = 10000000; % daily users (from sources it is 122000000, needed to reduce it for runtime since even at 5Ndays, it would take 5 hours)
hours_uploaded_every_minute = 500; % hours of videos uploaded (from sources)
recommended_vids = 10; % number of videos on one's recommended page without scrolling
avg_vid_length = 12; % average length of a video in minutes (from source)

% Calculated Statistics
daily_hours = 24*60*60*hours_uploaded_every_minute; % hours of video uploaded a day
daily_vids = daily_hours/(60/avg_vid_length); % total videos uploaded each day

% probabilities
recommmend_prob = recommended_vids/daily_vids; % initial chance of viewing a video from reommended
like_ns_prob = .005; % probability of liking a video if not subscribed
like_sub_prob = .5; % probability of liking a video if subscribed
dislike_prob = .0025; % probability of disliking a video (will not dislike if subscribed)
comment_ns_prob = .00125; % probability of commenting on video if not subscribed
comment_sub_prob = .025; % probability of commenting on video if subscribed

Niterations = 10; % total number of iterations
interval = .015; % the amount sub_prob is increased each iteration

% Data Tracking
total_views = zeros(Niterations,1); 
total_likes = zeros(Niterations,1);
total_dislikes = zeros(Niterations,1);
total_comments = zeros(Niterations,1); % total comments
total_subs = zeros(Niterations,1); % total subscribers

% exponential bases for the following stats in the respective function
a=1.05; % views
b=1.25; % likes
c=1.5; % subscribers
d=2; % comments

% initialize sub_prob vector
sub_prob=zeros(Niterations,1);
sub_prob(1)=.015;
for k = 2:Niterations
    sub_prob(k) = sub_prob(k-1)+interval;
end

% for each iteration
for k = 1:Niterations
    subscribed = zeros(Nusers,1); % logical array of all users, true if subcribed, false if not
    fprintf('Iteration: %d\n\n',k) % print each iteration to track progress
    % step through time (assuming one video uploaded a day)
    for i=1:Ndays
        % stat trackers per unit of time
        viewed = 0;
        liked = 0;
        disliked = 0;
        commented = 0;
        subbed = 0;

        % for each user
        for j=1:Nusers
            if subscribed(j) % if the user is subscribed
                viewed = viewed+1; % they view the video
                if rand > 1-like_sub_prob % with like_sub_prob chance
                    liked = liked+1; % the user likes the video
                end
                if rand > 1-comment_sub_prob % with comment_sub_prob_chance
                    commented = commented+1; % the user comments
                end
            else % otherwise
                if disliked == 0 || viewed == 0 % if the video has no dislikes or no views
                    max_p = 1; % set the max probability to 1
                else
                    max_p = disliked/viewed; % otherwise set the max probability to the proportion of dislikes to views
                end
                % the function for determining view chance: at 0 views, likes,
                % subs and dislikes, this probability is the same as
                % recommended probability. The presence of any of these
                % statistics increases the probability of viewing the video to
                % at most the proportion of dislikes to views
                p = min(recommmend_prob*a^viewed*b^liked*c^subbed*d^commented,max_p);
                if rand > 1-p % with a p percent chance
                    viewed = viewed+1;
                    if rand > 1-sub_prob(k) % with a sub_prob chance
                        % subscribe
                        subscribed(j)=1;
                        subbed=subbed+1;
                        if rand > 1-like_sub_prob % like with a like_sub_prob chance
                            liked = liked+1;
                        end
                        if rand > 1-comment_sub_prob
                            commented = commented+1; % comment with a comment_sub_prob chance
                        end
                    else % otherwise
                        if rand > 1-like_ns_prob % like with a like_ns_prob chance
                            liked = liked+1;
                        elseif rand > 1-dislike_prob % or dislike with a dislike_prob chance
                            disliked = disliked+1;
                        end
                        if rand > 1-comment_ns_prob % comment with a comment_ns_chance
                            commented = commented+1;
                        end
                    end
                end    
            end
        end
        subscribed = shuffle(Nusers,subscribed); % randomize order of subscribers 
                                                 % (this is akin to randomizing the order in which users watch the video)
        % Update total statistics
        total_views(k)=total_views(k)+viewed;
        total_likes(k)=total_likes(k)+liked;
        total_dislikes(k)=total_dislikes(k)+disliked;
        total_comments(k)=total_comments(k)+commented;
        total_subs(k)=total_subs(k)+subbed;
    end
end
% Graph all statistics against sub_prob
figure()
plot(sub_prob,total_subs, 'r')
hold on
xlabel('sub prob')
ylabel('totals')
title('Investigation of Sub Probability')
plot(sub_prob,total_views, 'k')
plot(sub_prob,total_likes, 'b')
plot(sub_prob,total_comments, 'g')
plot(sub_prob,total_dislikes, 'y')
hold off

% Graph subs, comments and dislikes against sub_prob
figure()
plot(sub_prob,total_subs, 'r')
hold on
xlabel('sub prob')
ylabel('totals')
title('Investigation of Sub Probability: Subs,Comments,Dislikes')
plot(sub_prob,total_comments, 'g')
plot(sub_prob,total_dislikes, 'y')
hold off

% Graph dislikes against sub_prob
figure()
title('Investigation of Sub Probability: Dislikes')
plot(sub_prob,total_dislikes, 'y')

toc % output the runtime for the program
end

% This is the Fisher-Yates shuffle algorithm implemented by user Jan on the
% MATLAB file exchange. This was implemented over simply using randperm
% because randperm is O(nlog(n)) whereas this shuffle algorithm is O(n).
% 
% Jan (2022). Shuffle (https://www.mathworks.com/matlabcentral/fileexchange/27076-shuffle), 
% MATLAB Central File Exchange. Retrieved April 17, 2022
function f = shuffle(n,X)
    for i = 2:n      % Knuth shuffle in forward direction:
       w    = ceil(rand * i);   % 1 <= w <= i
       t    = X(w);
       X(w) = X(i);
       X(i) = t;
    end
    f = X;
end