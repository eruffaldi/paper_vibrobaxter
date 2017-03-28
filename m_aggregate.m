if exist('sessions') == 0
    load('loaded');
end
%%
sessions.man_act_L_pct = zeros(height(sessions),1);
sessions.man_act_H_pct = zeros(height(sessions),1);
sessions.man_act_LH_pct = zeros(height(sessions),1);
sessions.joints_act_L_pct = zeros(height(sessions),1);
sessions.joints_act_H_pct = zeros(height(sessions),1);
sessions.joints_act_LH_pct = zeros(height(sessions),1);
sessions.joints_act_L_count = zeros(height(sessions),1);
sessions.joints_act_LH_count = zeros(height(sessions),1);
sessions.joints_act_H_count= zeros(height(sessions),1);
sessions.samples = sessions.man_act_L_pct ;

%%
% good manip increasing
threshold_man = [0.04,0.07];  % HIGH, LOW
threshold_joint = [0.0872665, 0.174533]; % LOW, HIGH

% robot values
jointmax0 = [3.0541, 2.618, 1.7016, 1.047, 3.059, 2.094, 3.059];
jointmin0 = [-3.0541, -0.05, -1.7016, -2.147, -3.059, -1.5707, -3.059];

jointmax0H = jointmax0-threshold_joint(1);
jointmax0L = jointmax0-threshold_joint(2);
jointmin0H = jointmin0+threshold_joint(1);
jointmin0L = jointmin0+threshold_joint(2);

hbsetup = [];
hbsetup.jointmax0 = jointmax0;
hbsetup.jointmin0 = jointmin0;
hbsetup.jointmax0L = jointmax0L;
hbsetup.jointmax0H = jointmax0H;
hbsetup.jointmin0L = jointmin0L;
hbsetup.jointmin0H = jointmin0H;
hbsetup.threshold_man = threshold_man;

%%
for I=1:height(sessions)
    data = sessions.data{I};
    n = height(data);
    
    % Regions: Mhigh Mlow normal
    qmL = data.man_index < threshold_man(2) & data.man_index > threshold_man(1);
    qmH = data.man_index < threshold_man(1);
    qmLH = data.man_index < threshold_man(2);
    sessions.man_act_L_count(I) = sum(qmL);
    sessions.man_act_H_count(I) = sum(qmH);
    sessions.man_act_LH_count(I) = sum(qmLH);
    sessions.man_act_L_pct(I) = sessions.man_act_L_count(I)*100/n;
    sessions.man_act_H_pct(I) = sessions.man_act_H_count(I)*100/n;
    sessions.man_act_LH_pct(I) = sessions.man_act_LH_count(I)*100/n;
    
    jointmaxL = repmat(jointmax0L,n,1);
    jointminL = repmat(jointmin0L,n,1);
    jointmaxH = repmat(jointmax0H,n,1);
    jointminH = repmat(jointmin0H,n,1);

    % Normalize each joint by product sum and scaling
    sc = 1.0./(jointmax0-jointmin0);
    bias = jointmin0;
    jsc = repmat(sc,n,1);
    jbias = repmat(bias,n,1);
    % then apply
    jn = (data.joints-jbias).*jsc;
    data.normalized = jn;
    Z = zeros(size(jn,1),size(jn,2),2);
    Z(:,:,1) = (1.0-jn); % distance to 1 
    Z(:,:,2) = (jn); % distance to 0
    Zn = min(Z,[],3); % minimum along
    data.normalizeddist = min(Zn,[],2);
    qH = sum(data.joints > jointmaxH | data.joints < jointminH,2);
    qL = sum((data.joints > jointmaxL & data.joints <= jointmaxH) | (data.joints < jointminL & data.joints > jointminH),2);
    qLH = sum(data.joints > jointmaxL | data.joints < jointminL,2);
    data.joints_L = qL > 0;
    data.joints_H = qH > 0;
    data.joints_LH = qLH > 0;
    data.man_L = qmL ;
    data.man_H = qmH ;
    data.man_LH = qmLH ;
    sessions.data{I} = data;
    
    sessions.joints_act_L_count(I) = sum(qL>0); % average of joints that are over threshold
    sessions.joints_act_H_count(I) = sum(qH>0);
    sessions.joints_act_LH_count(I) = sum(qLH>0);
    sessions.joints_act_L_pct(I) = 100*sessions.joints_act_L_count(I,1)/n; % average overall threshold
    sessions.joints_act_H_pct(I) = 100*sessions.joints_act_H_count(I,1)/n;
    sessions.joints_act_LH_pct(I) = 100*sessions.joints_act_LH_count(I,1)/n;
    sessions.joints_maxdist(I) = max(data.normalizeddist);
    sessions.joints_mindist(I) = min(data.normalizeddist);
    size(std(data.normalizeddist))
    sessions.joints_stddist(I) = std(data.normalizeddist);
    sessions.joints_meandist(I) = mean(data.normalizeddist);
    sessions.samples(I) = n;
end

%%
%save('loaded.mat','sessions','hbsetup')

