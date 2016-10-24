if exist('sessions') == 0
    load('loaded');
end
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

jointmax0L = jointmax0-threshold_joint(1);
jointmax0H = jointmax0-threshold_joint(2);
jointmin0L = jointmin0+threshold_joint(1);
jointmin0H = jointmin0+threshold_joint(2);

for I=1:height(sessions)
    data = sessions.data{I};
    n = height(data);
    
    sessions.man_act_L_count(I) = sum(data.man_index > threshold_man(1));
    sessions.man_act_H_count(I) = sum(data.man_index > threshold_man(2));
    sessions.man_act_L_pct(I) = sessions.man_act_L_count(I)*100/n;
    sessions.man_act_H_pct(I) = sessions.man_act_H_count(I)*100/n;

    jointmaxL = repmat(jointmax0L,n,1);
    jointminL = repmat(jointmin0L,n,1);
    jointmaxH = repmat(jointmax0H,n,1);
    jointminH = repmat(jointmin0H,n,1);
    % first count each joint activation, then sum all columns so that we
    % count number of acticated joints
    qH = sum(data.joints > jointmaxH | data.joints < jointminH,2);
    qL = sum(data.joints > jointmaxL | data.joints < jointminL,2);
    sessions.joints_act_L_count(I) = sum(qL>0); % average of joints that are over threshold
    sessions.joints_act_H_count(I) = sum(qH>0);
    sessions.joints_act_L_pct(I) = 100*sessions.joints_act_L_count(I,1)/n; % average overall threshold
    sessions.joints_act_H_pct(I) = 100*sessions.joints_act_H_count(I,1)/n;
    sessions.samples(I) = n;
end

%%
save('loaded.mat','sessions')

