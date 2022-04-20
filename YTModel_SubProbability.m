function YTModel_SubProbability
%YTMODEL
% This function models a youtube channel posting videos starting with 0 
% views and 0 subscribers. Assuming one video is uploaded a day, this
% each day the total number of users are iterated through and have a chance
% to view the video. Their chance of viewing the video increases as views
% accumulate on that video. Additionally, each viewer has a percent chance
% of subscribing. A subscribed viewer has a significantly higher chance of
% viewing future videos.

% 02/2022 by John Bernardin

tic

rng(42)

% Basic Statistics
Ndays = 52; % number of days
Nusers = 10000000; % daily users (from sources it is 122000000, needed to reduce it for runtime since even at 5Ndays, it would take 5 hours)
hours_uploaded_every_minute = 500; % hours of videos uploaded (from sources)
recommended_vids = 10; % number of videos on one's recommended page without scrolling
avg_vid_length = 12; % average length of a video in minutes (from source)

% Graphing Vectors
views = zeros(Ndays,1); % views per unit of time
likes = zeros(Ndays,1); % likes per unit of time
dislikes = zeros(Ndays,1); % dislikes per unit of time
comments = zeros(Ndays,1); % comments per unit of time
subs = zeros(Ndays,1); % subscribers per unit of time

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

subscribed = zeros(Nusers,1);
Niterations = 10;
interval = .015;

% Data Tracking
total_views = zeros(Niterations,1); 
total_likes = zeros(Niterations,1);
total_dislikes = zeros(Niterations,1);
total_comments = zeros(Niterations,1); % total comments
total_subs = zeros(Niterations,1); % total subscribers

a=1.05;
b=1.25;
c=1.5;
d=2;

sub_prob=zeros(Niterations,1);
sub_prob(1)=.015;

for k = 2:Niterations
    sub_prob(k) = sub_prob(k-1)+interval;
end

for k = 1:Niterations
    fprintf('Iteration: %d\n\n',k)
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
            if subscribed(j)
                viewed = viewed+1;
                if rand > 1-like_sub_prob
                    liked = liked+1;
                end
                if rand > 1-comment_sub_prob
                    commented = commented+1;
                end
            else
                max_p = disliked/viewed;
                if max_p == 0 || isnan(max_p)
                    max_p = 1;
                end
                p = min(recommmend_prob*a^viewed*b^liked*c^subbed*d^commented,max_p);
                if rand > 1-p % with a p percent chance
                    viewed = viewed+1;
                    if rand > 1-sub_prob(k) % with a sub_prob chance
                        % subscribe
                        subscribed(j)=1;
                        subbed=subbed+1;
                        if rand > 1-like_sub_prob
                            liked = liked+1;
                        end
                        if rand > 1-comment_sub_prob
                            commented = commented+1;
                        end
                    else
                        if rand > 1-like_ns_prob
                            liked = liked+1;
                        elseif rand > 1-dislike_prob
                            disliked = disliked+1;
                        end
                        if rand > 1-comment_ns_prob
                            commented = commented+1;
                        end
                    end
                end    
            end
        end
        subscribed = shuffle(Nusers,subscribed); % randomize order of subscribers 
                                                 % (this is akin to randomizing the order in which users watch the video)
        total_views(k)=total_views(k)+viewed;
        total_likes(k)=total_likes(k)+liked;
        total_dislikes(k)=total_dislikes(k)+disliked;
        total_comments(k)=total_comments(k)+commented;
        total_subs(k)=total_subs(k)+subbed;

        % update graphing vectors
        views(i)=viewed;
        likes(i)=liked;
        dislikes(i)=disliked;
        comments(i)=commented;
        subs(i)=subbed;
    end
end
figure()
plot(sub_prob,total_subs, 'r')
hold on
xlabel('time')
ylabel('users')
title('Investigation of Sub Probability')
plot(sub_prob,total_views, 'k')
plot(sub_prob,total_likes, 'b')
plot(sub_prob,total_comments, 'g')
plot(sub_prob,total_dislikes, 'y')
hold off

figure()
plot(sub_prob,total_subs, 'r')
hold on
xlabel('time')
ylabel('users')
title('Investigation of Sub Probability: Subs,Comments,Dislikes')
plot(sub_prob,total_comments, 'g')
plot(sub_prob,total_dislikes, 'y')
hold off

figure()
title('Investigation of Sub Probability: Dislikes')
plot(sub_prob,total_dislikes, 'y')

toc
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