%%
mysetup('rosbag');

%% collezionare e dividere i partecipanti
load users
for I=1:length(users)
    users{I}.bag = strrep(users{I}.bag,'exp_results','data');
end

sessions = maketab(users);
sessions.hasbracelet = cell2mat(sessions.hasbracelet);

%%
load time_real_exp
timt = sortrows(maketab(tim),{'Name','hasbracelet'});

%% load data for all users
sessions.data = cell(height(sessions),1);
sessions.duration = zeros(height(sessions),1);
sessions.segments = zeros(height(sessions),3,2);

for I=1:height(sessions)
    data = processbag(sessions.bag{I});
    sessions.duration(I) = data.duration;
    sessions.data{I} = data.data;
    x = data;
    m = [x.k2_ini_pick,x.k2_end_pick;x.k2_ini_place,x.k2_end_place;x.k2_ini_leave,x.k2_end_leave];
    sessions.segments(I,:,:) = m;

end
sessions.odata = sessions.data;
sessions.oduration = sessions.duration;

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
    predu = q.time(end)-q.time(1);
    q = q(bnact,:);
    q.time = q.time-q.time(1);
    [predu,q.time(end),sum(bnact)/length(bact)]
    st = q.time(2)-q.time(1);
    sessions.duration(I) = st*height(q);
    sessions.data{I} = q;
end


%%
save('loaded.mat','sessions')
