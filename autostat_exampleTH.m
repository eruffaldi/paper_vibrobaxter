%%
load 'toh1ds'
%ogni trial si svolge su 5 target points, nell'analisi abbiamo considerato i target points come fattore, quindi avevamo due fattori: navigation e target point
%
%    part    tr_no    ptexp1    err          vis    nav
%     1      1        1          0.012854    2      1  
%     1      1        2          0.011822    2      1  


toh1ds.group = ones(size(toh1ds,1),1);
toh1ds.targetpoint = toh1ds.ptexp1 ; 
toh1ds.trial = toh1ds.tr_no;
toh1ds.user = toh1ds.part;
toh1ds.part = [];
toh1ds.tr_no = [];
toh1ds.ptexp1 = [];
sessions = dataset2table(toh1ds);

%%
model = [];
model.conditions = {'targetpoint','nav'};
model.subjectsession = 'trial'; % which session of user
model.targets = {{'err','error'}};
model.errorplots = {{'err'}}; %{{'duration'},{'man_act_L_pct','man_act_H_pct','joints_act_L_pct','joints_act_H_pct'}};
model.nolog = 1;
cstats = autostat(sessions,model);
