%
if exist('sessions') == 0
    load('loaded');
end

%
% TODO special: pct are computed as normalized count, that's not really a
% binomial due to the temporal aspect.
%%
% GLM do anova over a logisic binomial model
% model = glm(...binomial)
% anova(model, test=Chisq)
% https://sites.ualberta.ca/~lkgray/uploads/7/3/6/2/7362679/23_-_binomial_anova.pdf
%
% Better
% http://www.theanalysisfactor.com/dependent-variables-never-meet-normality/
% http://www.ats.ucla.edu/stat/stata/faq/proportion.htm
summary(sessions)
%%
ss = sessions(:,{'hasbracelet','joints_act_H_count','man_act_LH_count','man_act_LH_pct','joints_act_LH_count','duration','joints_act_LH_pct'});
ss.man_act_LH_bin = ss.man_act_LH_count > 0;

[ct,chi2,p,labels] = crosstab(ss.hasbracelet,[h,p,stats] = fishertest(ct)ss.man_act_LH_bin);
fishertest(ct)

%%

glmeJLH = fitglme(ss,'hasbracelet ~ 1 + joints_act_LH_pct','Distribution','Binomial','Link','logit');
glmeJLH

glmeD = fitglme(ss,'hasbracelet ~ duration');
glmeD

glmeMLH = fitglme(ss,'hasbracelet ~ 1 + man_act_LH_pct');
glmeMLH

glmePJLH = fitglme(ss,'hasbracelet ~ joints_act_LH_count','Distribution','Poisson','Link','log');
glmePJLH

glmePMLH = fitglme(ss,'hasbracelet ~ joints_act_H_count','Distribution','Poisson','Link','log');
glmePMLH


%%
model = [];
model.conditions = {'hasbracelet'};
model.subjectsession = 'relindex'; % which session of user
model.targets = {{'duration','s'}, {'man_act_L_pct','pct'},{'man_act_LH_pct','pct'},{'man_act_H_pct','pct'},{'joints_act_LH_pct','pct'},{'joints_act_L_pct','pct'},{'joints_act_H_pct','pct'}};
model.errorplots = {{'duration'},{'man_act_L_pct','man_act_LH_pct','man_act_H_pct','joints_act_L_pct','joints_act_H_pct','joints_act_LH_pct'}};
model.applylog = 0;
model.plots =1;
cstats = autostat(sessions,model);

cstats

%%
model = [];
model.conditions = {'hasbracelet'};
model.subjectsession = 'relindex'; % which session of user
model.targets = {{'duration','s'}, {'man_act_L_pct','pct'},{'man_act_LH_pct','pct'},{'man_act_H_pct','pct'},{'joints_act_LH_pct','pct'},{'joints_act_L_pct','pct'},{'joints_act_H_pct','pct'}};
model.errorplots = {{'duration'},{'man_act_L_pct','man_act_LH_pct','man_act_H_pct','joints_act_L_pct','joints_act_H_pct','joints_act_LH_pct'}};
model.applylog = 0;
model.plots =1;
cstats = autostat(sessions,model);

cstats


%%
model = [];
model.conditions = {'hasbracelet'};
model.subjectsession = 'relindex'; % which session of user
model.targets = {{'duration','s'}, {'joints_maxdist','dist1'},{'joints_meandist','dist1'}};
model.errorplots = {}; % {{'duration'},{'man_act_L_pct','man_act_LH_pct','man_act_H_pct','joints_act_L_pct','joints_act_H_pct','joints_act_LH_pct'}};
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
