function YTModel
%YTMODEL
% This function models a youtube channel posting videos starting with 0 
% views and 0 subscribers. Assuming one video is uploaded a day, this
% each day the total number of users are iterated through and have a chance
% to view the video. Their chance of viewing the video increases as views
% accumulate on that video. Additionally, each viewer has a percent chance
% of subscribing. A subscribed viewer has a significantly higher chance of
% viewing future videos.

% 02/2022 by John Bernardin


% Data Tracking
total_views = 0; 
total_subs = 0; % total subscribers

% Basic Statistics
Ndays = 1000; % total uploads (assuming one video per day)
Nusers = 122000; % daily users (from sources it is 122000000, needed to reduce it for runtime)
hours_uploaded_every_minute = 500; % hours of videos uploaded (from sources)
recommended_vids = 10; % number of videos on one's recommended page without scrolling
avg_vid_length = 12; % average length of a video in minutes (from source)

% Graphing Vectors
views = zeros(Ndays,1);
subs = zeros(Ndays,1); % subscribers

% Calculated Statistics
daily_hours = 24*60*60*hours_uploaded_every_minute; % hours of video uploaded a day
daily_vids = daily_hours/(60/avg_vid_length); % total videos uploaded each day

% probabilities
recommmend_prob = recommended_vids/daily_vids; % initial chance of viewing a video from reommended
sub_prob = .0001; % chance of subscribing after viewing (chosen arbitrarily)
sub_view_prob = .2; % chance of viewing from subscription box (chosen arbitrarily)

% step through time (assuming one video uploaded a day)
for i=1:Ndays
    subscribers = total_subs; % copy this so it doesn't effect loop iteration
    viewers = Nusers-total_subs; % copy this so it doesn't effect loop iteration
    viewed = zeros(viewers,1); % logical array indicating whether a video has been viewed or not
    subbed = 0; % track how many people subscribed today
    % subscriber case
    for j=1:total_subs
        if rand > 1-sub_prob % with a sub_prob percent chance
            subscribers=subscribers+1; % increment the amount of subscribers
        end
    end
    total_subs=subscribers;
    % viewer case
    for j=1:viewers
        % compute the probability of viewing the video, with the
        % probability increasing by a factor of 2 to the power of the total
        % amount of people who have viewed the video
        p = min(recommmend_prob*2^sum(viewed),1);
        if rand > 1-p % with a p percent chance
            viewed(j)=1; % indicate that the video has been viewed
            if rand > 1-sub_view_prob % with a sub_view_prob chance
                % gain a subscriber
                total_subs=total_subs+1; 
                subbed=subbed+1;
            end
        else
            viewed(j)=0; % otherwise indicate that the video has not been viewed
        end    
    end
    % update total viewcount
    viewcount = sum(viewed);
    total_views=total_views+viewcount;
    % update graphing vectors
    views(i)=viewcount;
    subs(i)=subbed;
end
subs
views
total_views
total_subs
end

