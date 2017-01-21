%
if exist('sessions') == 0
    load('loaded');
end

%%
model = [];
model.conditions = {'hasbracelet'};
model.subjectsession = 'relindex'; % which session of user
model.targets = {{'duration','s'}, {'man_act_L_pct','pct'},{'man_act_LH_pct','pct'},{'man_act_H_pct','pct'},{'joints_act_LH_pct','pct'},{'joints_act_L_pct','pct'},{'joints_act_H_pct','pct'}};
model.errorplots = {{'duration'},{'man_act_L_pct','man_act_LH_pct','man_act_H_pct','joints_act_L_pct','joints_act_H_pct','joints_act_LH_pct'}};
model.applylog = 0;
model.plots =0 ;
cstats = autostat(sessions,model);

cstats

set(0,'defaultaxesfontname','Helvetica');
set(0,'defaulttextfontname','Helvetica');

set(0,'defaultaxesfontsize',16);
set(0,'defaulttextfontsize',16);

%%

%%
% Additional plots
%boxplot(sessions.man_act_L_pct,{sessions.hasbracelet,sessions.group})
%boxplot(sessions.man_act_H_pct,{sessions.hasbracelet,sessions.group})
%boxplot(sessions.duration,{sessions.hasbracelet,sessions.group})
%boxplot(sessions.joints_act_L_pct,{sessions.hasbracelet,sessions.group});
%boxplot(sessions.joints_act_H_pct,{sessions.hasbracelet,sessions.group});
