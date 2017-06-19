%%
mysetup('rosbag');

%% collezionare e dividere i partecipanti
load users
sessions = maketab(users);
sessions.hasbracelet = cell2mat(sessions.hasbracelet);

%%
load time_real_exp
timt = sortrows(maketab(tim),{'Name','hasbracelet'});

%% load data for all users
sessions.data = cell(height(sessions),1);
sessions.duration = zeros(height(sessions),1);

for I=1:height(sessions)
    data = processbag(sessions.bag{I});
    sessions.duration(I) = data.duration;
    sessions.data{I} = data.data;

end
sessions.odata = sessions.data;

%%
sessions = sortrows(sessions,{'user','hasbracelet'});

%% cut by end_pick ... int_leave
for I=1:height(sessions)
    q = sessions.odata{I};
    w = 1:height(q);
   bpick = w >= timt.ini_pick{I} & w <= timt.end_pick{I};
bplace = w >= timt.ini_place{I} & w <= timt.end_place{I};
bleave = w >= timt.ini_leave{I} & w <= timt.end_leave{I};
bact = bpick | bplace | bleave;
bnact = ~bact;
    
    %is1 = find(q.time >= tim(I).end_pick,1,'first');
    %ie1 = find(q.time <= tim(I).ini_leave,1,'first');
    q = q(bnact,:);
    q.time = q.time-q.time(1);
    sessions.duration(I) = q.time(end);
    sessions.data{I} = q;
end


%%
save('loaded.mat','sessions')

%%
sessions.man_act_L_pct = zeros(height(sessions),1);
sessions.man_act_H_pct = zeros(height(sessions),1);
sessions.joints_act_L_pct = zeros(height(sessions),1);
sessions.joints_act_H_pct = zeros(height(sessions),1);
sessions.joints_act_L_count = zeros(height(sessions),1);
sessions.joints_act_H_count= zeros(height(sessions),1);
sessions.samples = sessions.man_act_L_pct ;


threshold_man = [0.04,0.07];
threshold_joint = [0.0872665, 0.174533];

% robot values
jointmax0 = [3.0541, 2.618, 1.7016, 1.047, 3.059, 2.094, 3.059];
jointmin0 = [-3.0541, -0.05, -1.7016, -2.147, -3.059, -1.5707, -3.059];

jointmax0L = jointmax0+threshold_joint(1);
jointmax0H = jointmax0+threshold_joint(2);
jointmin0L = jointmin0+threshold_joint(1);
jointmin0H = jointmin0+threshold_joint(2);

for I=1:height(sessions)
    data = sessions.data{I};
    n = height(data);

    sessions.man_act_L_pct(I) = 100*sum(data.man_index > threshold_man(1))/n;
    sessions.man_act_H_pct(I) = 100*sum(data.man_index > threshold_man(2))/n;

    jointmaxL = repmat(jointmax0L,n,1);
    jointminL = repmat(jointmin0L,n,1);
    jointmaxH = repmat(jointmax0H,n,1);
    jointminH = repmat(jointmin0H,n,1);
    % first count each joint activation, then sum all columns so that we
    % count number of acticated joints
    qH = sum(data.joints > jointmaxH | data.joints < jointminH,2);
    qL = sum(data.joints > jointmaxL | data.joints < jointminL,2);
    sessions.joints_act_L_pct(I,1) = 100*sum(qL>0)/n; % average overall threshold
    sessions.joints_act_H_pct(I,1) = 100*sum(qH>0)/n;
    sessions.joints_act_L_count(I,:) = mean(qL); % average of joints that are over threshold
    sessions.joints_act_H_count(I,:) = mean(qH);
    sessions.samples(I) = n;
end

%%
% replace the boxplot with the whisker

%%
boxplot(sessions.man_act_L_pct,{sessions.hasbracelet,sessions.group})

%%
boxplot(sessions.man_act_H_pct,{sessions.hasbracelet,sessions.group})

%%
boxplot(sessions.duration,{sessions.hasbracelet,sessions.group})

%%
boxplot(sessions.joints_act_L_pct,{sessions.hasbracelet,sessions.group});


%%
boxplot(sessions.joints_act_H_pct,{sessions.hasbracelet,sessions.group});


%% 
% TODO ANOVA, evenutally anche con statsmodel python