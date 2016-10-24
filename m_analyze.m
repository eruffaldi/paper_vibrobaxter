%
if exist('sessions') == 0
    load('loaded');
end

%%
model = [];
model.conditions = {'hasbracelet'};
model.targets = {{'duration','s'}, {'man_act_L_pct','pct'},{'man_act_H_pct','pct'},{'joints_act_L_pct','pct'}};
model.subjectsession = 'relindex'; % which session of user
cstats = autostat(sessions,model);

cstats

%%
% Additional plots
%boxplot(sessions.man_act_L_pct,{sessions.hasbracelet,sessions.group})
%boxplot(sessions.man_act_H_pct,{sessions.hasbracelet,sessions.group})
%boxplot(sessions.duration,{sessions.hasbracelet,sessions.group})
%boxplot(sessions.joints_act_L_pct,{sessions.hasbracelet,sessions.group});
%boxplot(sessions.joints_act_H_pct,{sessions.hasbracelet,sessions.group});
